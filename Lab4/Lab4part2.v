module part2(Clock, Reset_b, Data, Function, ALUout);
	input Clock;
	input Reset_b;
	input [3:0] Data; 
	input [2:0] Function;
	wire [3:0] c0, c6;
	wire [4:0] c1;
	wire [7:0] c2, c3, c4, c5, c7;
	reg [7:0] out;
	output reg [7:0] ALUout; //declare output for always block

	always@(posedge Clock)
	begin
		if (Reset_b == 1'b0)
			ALUout <= 0;
		else
			ALUout <= out;
	end
	
	//modules performing operations on A and B regardless of function
	part2adder o0(Data, ALUout[3:0], 0, c0, c6); 
	verilogaddition o1(Data, ALUout[3:0], c1);
	signextension o2(ALUout[3:0], c2);
	atleast1 o3(Data, ALUout[3:0], c3);
	all1 o4(Data, ALUout[3:0], c4);
	leftshift o5(Data, ALUout[3:0], c5); //check size of this output
	multiply o6(Data, ALUout[3:0], c7); 

	always@(*) //declare always block
	begin
		case (Function) //start case statement to determine which output to pass through
			3'b000: out = {3'b000, c6[3], c0}; //case 0
			3'b001: out = {3'b000, c1}; //case 1
			3'b010: out = c2; //case 2
			3'b011: out = c3; //case 3
			3'b100: out = c4; //case 4
			3'b101: out = c5; //case 5
			3'b110: out = c7; //case 6
			3'b111: out = ALUout; //case 7
			default: out = 1'b0; //output arbitrary 0 if input is undefined
		endcase
	end
	
endmodule

module part2adder(a, b, c_in, s, c_out);
	input [3:0] a; //init inputs
	input [3:0] b;
	input c_in;
	output [3:0] s; //init output
	output [3:0] c_out;
	//wire [2:0] c; //init wires
	
	fulladder a1(a[0], b[0], c_in, s[0], c_out[0]); //adder 1
	fulladder a2(a[1], b[1], c_out[0], s[1], c_out[1]); //adder 2
	fulladder a3(a[2], b[2], c_out[1], s[2], c_out[2]); //adder 3
	fulladder a4(a[3], b[3], c_out[2], s[3], c_out[3]); //adder 4
	
endmodule //lab part 2 (4-bit carry-on adder)

module fulladder(a, b, c_in, s, c_out);
	input a, b, c_in; //init inputs
	output s, c_out; //init outputs
	
	assign c_out = a * b + a * c_in + b * c_in; //logic statement for cout
	assign s = a ^ b ^ c_in; //logic statement for sum
	
endmodule //fulladder module to be used for 4-bit adder

module verilogaddition(a, b, s);
	input [3:0] a;
	input [3:0] b;
	output [4:0] s;
	
	assign s = a + b; //use standard verilog addition
	
endmodule //verilogaddition module

module signextension(b, s);
	input [3:0] b;
	output [7:0] s;
	
	assign s = {{4{b[3]}}, b};
	
endmodule //sign extension module

module atleast1(a, b, s);
	input [3:0] a;
	input [3:0] b;
	output reg [7:0] s;
	
	always @(*)
	begin
		if (|{a, b})
			s = 8'b00000001;
		else
			s = 8'b00000000;
	end
	
endmodule //module to determine whether at least one of the bits is 1

module all1(a, b, s);
	input [3:0] a;
	input [3:0] b;
	output reg [7:0] s;
	
	always @(*)
	begin
		if (&{a, b}) 
			s = 8'b00000001;
		else 
			s = 8'b00000000;
	end
	
endmodule //module to determine whether all of the bits are 1s

module leftshift(a, b, s);
	input [3:0] a;
	input [3:0] b;
	output [7:0] s;
	
	assign s = b << a;
	
endmodule //module to shift b by a bits
	
module multiply(a, b, s);
	input [3:0] a;
	input  [3:0] b;
	output [7:0] s;
	
	assign s = a * b;
	
endmodule //module to multiple a and b