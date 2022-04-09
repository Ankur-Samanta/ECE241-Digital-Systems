module part3(ClockIn, Resetn, Start, Letter, DotDashOut);
	input Resetn, Start, ClockIn;
	input [2:0] Letter;
	output DotDashOut;
	
	wire [11:0] LUTout;
	//lookup table to store codes
	LUT lut1(.letter(Letter), .lutout(LUTout)); 
	
	
	wire Enable;
	RateDivider rd1(.clock(ClockIn), .reset(Resetn), .enable(Enable));
	
	wire rotateleft;
	rotater r1(.clock(ClockIn), .reset(Resetn), .enable(Enable), .rotaterout(rotateleft));
	
	wire [11:0] SRout; //output of shift register
	//now we want to read out the bits out of a shift register
	wire nreset, nstart, nrotateleft;
	assign nreset = ~Resetn;
	assign nstart = ~Start;
	assign nrotateleft = ~rotateleft;
	shiftregister sr1(.clock(ClockIn), .reset(nreset), .parallelload(nstart), .rotateright(nrotateleft), .asright(1'b0), .datain(LUTout), .q(SRout));
	assign DotDashOut = SRout[11];
	
endmodule

module LUT(letter, lutout);
	input [2:0] letter;
	output reg [11:0] lutout;
	
	always@(*)
	begin
		case (letter[2:0]) //letter selected by Letter input
			//Note: mintime is 0.5 seconds
			//encode the pattern for each letter using sedquence of 1s and 0s
			//0 or 1 is 0.5 seconds in duration
			//single 0 is a pause or off
			//single 1 is a dot
			//111 is a dash
			3'b000: lutout = 12'b010111000000; //case 1: A
			3'b001: lutout = 12'b011101010100; //Case 2: B
			3'b010: lutout = 12'b011101011101; //Case 3: C
			3'b011: lutout = 12'b011101010000; //Case 4: D
			3'b100: lutout = 12'b010000000000; //Case 5: E
			3'b101: lutout = 12'b010101110100; //Case 6: F
			3'b110: lutout = 12'b011101110100; //Case 7: G
			3'b111: lutout = 12'b010101010000; //Case 8: H
			default: lutout = 12'b010111000000; //Default Case: A
		endcase
	end
	
endmodule


module RateDivider(clock, reset, enable);
	input clock, reset;
	output reg enable;
	reg [10:0] RDout;
	
	always@(posedge clock, negedge reset)
	begin 
		if (reset == 1'b0)
			begin
				enable <= 1'b0;
				RDout <= 11'b00011111001;
			end
		else if (enable)
			begin
				enable <= ~enable;
				RDout <= 11'b00011111001;
			end
		else if (RDout == 11'b00000000001)
			enable <= 1'b1;
		else 
			RDout <= RDout - 1;
	end
endmodule


module rotater(clock, reset, enable, rotaterout);
	input clock, reset, enable;
	output reg rotaterout;
	
	always @(posedge clock, negedge reset)
	begin
		if (reset == 1'b0)
			rotaterout <= 1'b0;
		else if (enable == 1'b1)
			rotaterout <= 1'b1;
		else
			rotaterout <= 1'b0; //make sure no matter what rotate value is assigned to something (0)
	end
endmodule

module shiftregister(clock, reset, parallelload, rotateright, asright, datain, q); //12-bit shift register
	input clock, reset, parallelload, rotateright, asright;
	input [11:0] datain;
	output [11:0] q;
	
	rotatingregister rr0(q[10], q[11], rotateright, datain[11], parallelload, clock, reset, q[11]);
	rotatingregister rr1(q[9], q[10], rotateright, datain[10], parallelload, clock, reset, q[10]);
	rotatingregister rr2(q[8], q[9], rotateright, datain[9], parallelload, clock, reset, q[9]);
	rotatingregister rr3(q[7], q[8], rotateright, datain[8], parallelload, clock, reset, q[8]);
	rotatingregister rr4(q[6], q[7], rotateright, datain[7], parallelload, clock, reset, q[7]);
	rotatingregister rr5(q[5], q[6], rotateright, datain[6], parallelload, clock, reset, q[6]);
	rotatingregister rr6(q[4], q[5], rotateright, datain[5], parallelload, clock, reset, q[5]);
	rotatingregister rr7(q[3], q[4], rotateright, datain[4], parallelload, clock, reset, q[4]);
	rotatingregister rr8(q[2], q[3], rotateright, datain[3], parallelload, clock, reset, q[3]);
	rotatingregister rr9(q[1], q[2], rotateright, datain[2], parallelload, clock, reset, q[2]);
	rotatingregister rr10(q[0], q[1], rotateright, datain[1], parallelload, clock, reset, q[1]);
	rotatingregister rr11(q[11], q[0], rotateright, datain[0], parallelload, clock, reset, q[0]);
	
endmodule

module rotatingregister(right, left, loadleft, d, loadn, clock, reset, q);
	input right, left, loadleft, d, loadn, clock, reset;
	output q;
	wire w1, w2;
	
	assign w1 = loadleft ? left : right;
	assign w2 = loadn ? w1 : d;
	flipflop ff1(.d(w2), .clock(clock), .reset(resetn), .q(q));
	
endmodule

module flipflop(d, clock, reset, q);
	input d, clock, reset;
	output reg q;
	
	always@(posedge clock, negedge reset)
	begin
		if(reset == 1'b1)
			q <= 0;
		else
			q <= d;
	end
endmodule
	
	