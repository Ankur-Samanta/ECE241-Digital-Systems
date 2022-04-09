module part1(Clock, Enable, Clear_b, CounterValue);
	input Clock, Enable, Clear_b;
	output [7:0] CounterValue;
	
	wire and0, and1, and2, and3, and4, and5, and6;
	Tff tff0(.clock(Clock), .clearb(Clear_b), .T(Enable), .Q(CounterValue[0]));
	assign and0 = Enable & CounterValue[0];
	Tff tff1(.clock(Clock), .clearb(Clear_b), .T(and0), .Q(CounterValue[1]));
	assign and1 = Enable & CounterValue[0] & CounterValue[1];
	Tff tff2(.clock(Clock), .clearb(Clear_b), .T(and1), .Q(CounterValue[2]));
	assign and2 = Enable & CounterValue[0] & CounterValue[1] & CounterValue[2];
	Tff tff3(.clock(Clock), .clearb(Clear_b), .T(and2), .Q(CounterValue[3]));
	assign and3 = Enable & CounterValue[0] & CounterValue[1] & CounterValue[2] & CounterValue[3];
	Tff tff4(.clock(Clock), .clearb(Clear_b), .T(and3), .Q(CounterValue[4]));
	assign and4 = Enable & CounterValue[0] & CounterValue[1] & CounterValue[2] & CounterValue[3] & CounterValue[4];
	Tff tff5(.clock(Clock), .clearb(Clear_b), .T(and4), .Q(CounterValue[5]));
	assign and5 = Enable & CounterValue[0] & CounterValue[1] & CounterValue[2] & CounterValue[3] & CounterValue[4] & CounterValue[5];
	Tff tff6(.clock(Clock), .clearb(Clear_b), .T(and5), .Q(CounterValue[6]));
	assign and6 = Enable & CounterValue[0] & CounterValue[1] & CounterValue[2] & CounterValue[3] & CounterValue[4] & CounterValue[5] & CounterValue[6];
	Tff tff7(.clock(Clock), .clearb(Clear_b), .T(and6), .Q(CounterValue[7]));
	
endmodule

module Tff(clock, clearb, T, Q);
	input clock, clearb, T;
	output reg Q;
	
	always @(posedge clock, negedge clearb)
	begin
		if (!clearb)
			Q <= 1'b0;
		else
			if (T)
				Q <= ~Q;
			else
				Q <= Q;
	end

endmodule