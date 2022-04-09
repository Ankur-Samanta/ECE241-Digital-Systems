`timescale 1ns / 1ps
`default_nettype none

module fill	(
	input wire CLOCK_50,            //On Board 50 MHz
	input wire [9:0] SW,            // On board Switches
	input wire [3:0] KEY,           // On board push buttons
	output wire [6:0] HEX0,         // HEX displays
	output wire [6:0] HEX1,         
	output wire [6:0] HEX2,         
	output wire [6:0] HEX3,         
	output wire [6:0] HEX4,         
	output wire [6:0] HEX5,         
	output wire [9:0] LEDR,         // LEDs
	output wire [7:0] x,            // VGA pixel coordinates
	output wire [6:0] y,
	output wire [2:0] colour,       // VGA pixel colour (0-7)
	output wire plot,               // Pixel drawn when this is pulsed
	output wire vga_resetn          // VGA resets to black when this is pulsed (NOT CURRENTLY AVAILABLE)
);    
	
	wire [3:0] CounterValue;
	
	part2 u0(CLOCK_50, ~KEY[0], SW[1:0], CounterValue);
	hex_decoder u1(CounterValue, HEX1);
endmodule

module part2(ClockIn, Reset, Speed, CounterValue);
	input ClockIn, Reset;
	input [1:0] Speed;
	output [3:0] CounterValue;
	
	wire Enable;
	wire nReset;
	wire [26:0] RateDividerOut;
	
	RateDivider RD1 (.clock(ClockIn), .reset(Reset), .speed(Speed), .ratedividerout(RateDividerOut));
	assign Enable = (RateDividerOut == 27'b000000000000000000000000000) ? 1'b1 : 1'b0; // 1'b1:1'b0
	assign nReset = ~Reset;
	DisplayCounter DC1 (.clock(ClockIn), .reset(nReset), .enable(Enable), .q(CounterValue));
endmodule
	
module RateDivider(clock, reset, speed, ratedividerout);
	input clock, reset;
	input [1:0] speed;
	output reg[26:0] ratedividerout;
	reg [26:0] q;
	
	always@(speed)
	begin
		case (speed)
			2'b00: q <= 27'b0;
			2'b01: q <= 27'b001011111010111100000111111;
			2'b10: q <= 27'b010111110101111000001111111;
			2'b11: q <= 27'b101111101011110000011111111;
			default: q <= 27'b0;
		endcase
	end
	
	always@ (posedge clock)
		begin
			if (reset)
				ratedividerout <= 27'b000000000000000000000000000;
			else if (ratedividerout == 27'b000000000000000000000000000)
				ratedividerout <= q;
			else
				ratedividerout <= ratedividerout - 1;
		end
	
endmodule

module DisplayCounter(clock, reset, enable, q);
	input clock, reset, enable;
	output reg[3:0] q;
	
	always@(posedge clock)
		begin
			if (reset == 1'b0) //1'b0
				q <= 4'b0000; //4'b0000
			else if (enable)
				q <= q + 1;
		end
endmodule

module hex_decoder(c, display);
	input [3:0] c;
	output reg [6:0] display;
	
	always @*
		begin
			case(c)
				4'b0000: display = 7'b1000000;
				4'b0001: display = 7'b1111001;
				4'b0010: display = 7'b0100100;
				4'b0011: display = 7'b0110000;
				4'b0100: display = 7'b0011001;
				4'b0101: display = 7'b0010010;
				4'b0110: display = 7'b0000010;
				4'b0111: display = 7'b1111000;
				4'b1000: display = 7'b0000000;
				4'b1001: display = 7'b0010000;
				4'b1010: display = 7'b0001000;
				4'b1011: display = 7'b0000011;
				4'b1100: display = 7'b1000110;
				4'b1101: display = 7'b0100001;
				4'b1110: display = 7'b0000110;
				4'b1111: display = 7'b0001110;
			endcase
		end
	
endmodule