module part2(a, b, c_in, s, c_out);
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