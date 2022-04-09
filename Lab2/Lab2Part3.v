`timescale 1ns/1ns //timescale

module hex_decoder(c, display); //init
	input [3:0] c; //input
	output reg [6:0] display; //output
	
	always @(*) //always block
		begin
			case (c) //case definition
				4'b0000: display = 7'b1000000; //Hexadecimal 0
				4'b0001: display = 7'b1111001; //Hexadecimal 1
				4'b0010: display = 7'b0100100; //Hexadecimal 2
				4'b0011: display = 7'b0110000; //Hexadecimal 3
				4'b0100: display = 7'b0011001; //Hexadecimal 4
				4'b0101: display = 7'b0010010; //Hexadecimal 5
				4'b0110: display = 7'b0000010; //Hexadecimal 6
				4'b0111: display = 7'b1111000; //Hexadecimal 7
				4'b1000: display = 7'b0000000; //Hexadecimal 8
				4'b1001: display = 7'b0010000; //Hexadecimal 9
				4'b1010: display = 7'b0001000; //Hexadecimal A
				4'b1011: display = 7'b0000011; //Hexadecimal b
				4'b1100: display = 7'b1000110; //Hexadecimal C
				4'b1101: display = 7'b0100001; //Hexadecimal d
				4'b1110: display = 7'b0000110; //Hexadecimal E
				4'b1111: display = 7'b0001110; //Hexadecimal F
				default: display = 7'b1111111; //Default case
			endcase
		end
endmodule //hex decoder