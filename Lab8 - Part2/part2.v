//
// This is the template for Part 2 of Lab 7.
//
// Paul Chow
// November 2021
//

module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;
   
   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;
   
   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel draw enable

   wire LoadX, LoadY, LoadDraw;
	
	control C0(.clock(iClock), .resetn(iResetn), .iloadx(iLoadX), .iplotbox(iPlotBox), .loadx(LoadX), .loady(LoadY), .loaddraw(LoadDraw), .oplot(oPlot));
	datapath d0(.clock(iClock), .reset(iResetn), .loadx(LoadX), .loady(LoadY), .loaddraw(LoadDraw), .xycoordinate(iXY_Coord), .color(iColour), .ox(oX), .oy(oY), .oc(oColour));

endmodule // part2

module control(clock, resetn, iloadx, iplotbox, loadx, loady, loaddraw, oplot);
	input clock, resetn, iloadx, iplotbox;
	output reg loadx, loady, loaddraw, oplot;
	
	reg[5:0] current_state, next_state;
	
	localparam	S_START = 5'd0,
					S_LOAD_X = 5'd1,
					S_LOAD_Y = 5'd2,
					S_DRAW = 5'd3;
	
	// Next state logic aka our state table
	always@(*)
	begin: state_table
			case (current_state)
				S_START:
				begin
					if (iplotbox) 
						next_state = S_LOAD_Y;
					else if (iloadx)
						next_state = S_LOAD_X;
				end
				S_LOAD_X: next_state = iloadx ? S_LOAD_X : S_START;
				S_LOAD_Y: next_state = iplotbox ? S_LOAD_Y : S_DRAW;
				S_DRAW: next_state = S_START;
			default: next_state = S_START;
		endcase
	end
	
	// Output logic aka all of our datapath control signals
	always@(*)
	begin: enable_signals
		// By default make all our signals 0
		loadx = 1'b0;
		loady = 1'b0;
		loaddraw = 1'b0;
	
		case (current_state)
			S_START: begin
				loadx = 1'b0;
				loady = 1'b0;
				loaddraw = 1'b0;
				end
			S_LOAD_X: begin
				loadx = 1'b1;
				end
			S_LOAD_Y: begin
				loady = 1'b1;
				end
			S_DRAW: begin
				loaddraw = 1'b1;
				oplot = 1'b1;
				end
		endcase
	end
	
	// current_state registers
	always@(posedge clock)
	begin: state_FFs
		if(!resetn)
			current_state <= S_START;
		else
			current_state <= next_state;
	end // state_FFS
endmodule

module datapath(clock, reset, loadx, loady, loaddraw, xycoordinate, color, ox, oy, oc);
	input clock, reset, loadx, loady, loaddraw;
	input [6:0] xycoordinate;
	input [2:0] color;
	output reg [7:0] ox;
	output reg [6:0] oy;
	output reg [2:0] oc;
	
	//registers
	reg [7:0] tx;
	reg [6:0] ty;
	reg [2:0] tc;
	reg [1:4] countx, county;
	
	// Registers tx, ty, tc, countx, county with respective input logic
	always@(posedge clock) begin
		if(!reset) begin
			tx <= 8'b0;
			ox <= 8'b0;
			ty <= 7'b0;
			oy <= 7'b0;
			tc <= 3'b0;
			oc <= 3'b0;
			countx <= 4'b0;
			county <= 4'b0;
		end
		else begin
			if (loadx) 
				tx = xycoordinate;
			if (loady) 
				ty = xycoordinate;
				tc = color;
			if (loaddraw)
				oc <= tc;
				//X COUNTER: increment if tc < 4, else 0
				if (countx < 4) begin
					countx = countx;
				end
				else begin
					countx = 4'b0;
				end
				
				ox <= tx + countx;
				
				//Y COUNTER: add 0 until county = 4; at which point take  most sig bits and pad
				oy <= ty + {county[1], county[2]};
				county <= county + 1;
				countx <= countx + 1;
		end
	end
endmodule
		
				
				
			
	
			