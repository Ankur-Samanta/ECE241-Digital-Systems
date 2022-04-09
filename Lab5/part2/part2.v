module part2(ClockIn, Reset, Speed, CounterValue);
	input ClockIn, Reset;
	input [1:0] Speed;
	output [3:0] CounterValue;
	
	wire Enable;
	wire nReset;
	wire [10:0] RateDividerOut;
	
	RateDivider RD1 (.clock(ClockIn), .reset(Reset), .speed(Speed), .ratedividerout(RateDividerOut));
	assign Enable = (RateDividerOut == 11'b00000000000) ? 1'b1 : 1'b0;
	assign nReset = ~Reset;
	DisplayCounter DC1 (.clock(ClockIn), .reset(nReset), .enable(Enable), .q(CounterValue));
endmodule
	
module RateDivider(clock, reset, speed, ratedividerout);
	input clock, reset;
	input [1:0] speed;
	output reg[10:0] ratedividerout;
	reg [10:0] q;
	
	always@(speed)
	begin
		case (speed)
			2'b00: q <= 11'b00000000000;
			2'b01: q <= 11'b00111110011;
			2'b10: q <= 11'b01111100111;
			2'b11: q <= 11'b11111001111;
			default: q <= 11'b00000000000;
		endcase
	end
	
	always@ (posedge clock)
		begin
			if (reset)
				ratedividerout <= 11'b00000000000;
			else if (ratedividerout == 11'b00000000000)
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
			if (reset == 1'b0)
				q <= 4'b0000;
			else if (enable)
				q <= q + 1;
		end
endmodule
