module part3(Clock, Resetn, Go, Divisor, Dividend, Quotient, Remainder);

	input Clock, Resetn, Go;
	input [3:0] Dividend, Divisor;
	output [3:0] Quotient, Remainder;
	
	reg [4:0] current_state, next_state; //initializing current and next state
	reg [2:0] current_bit_counter, next_bit_counter; //initializing current and next bit counter
	reg [8:0] register_A, next_register_A; //initializing current and next remainder quotient concatenation
	
	localparam	S_RESTORE			= 5'd0,
					S_BITCHECK			= 5'd1,
					S_SHIFT				= 5'd2,
					S_SUB		   		= 5'd3,
					S_ADD 				= 5'd4,
					S_SHIFTCOMPLETE	= 5'd5; //initializing local params
						
	// Next state logic aka our state table
	always@(*)
	begin: state_table
		case (current_state)
			S_RESTORE: next_state = (Go == 1) ? S_BITCHECK : S_RESTORE;
			S_BITCHECK: next_state = (current_bit_counter < 4) ? S_SHIFT : S_SHIFTCOMPLETE; 
			//check for condition that sequence cycles through until all bits of dividend have been shifted out
			S_SHIFT: next_state = S_SUB;
			S_SUB: next_state = S_ADD;
			S_ADD: next_state = S_BITCHECK;
			default;
		endcase
	end // state_table
	
	// Output logic aka all of our datapath control signals
	// operations
	always@(*)
	begin: operations
		next_bit_counter <= current_bit_counter;
		next_register_A[8:0] <= register_A[8:0];
		
		case (current_state)
			S_RESTORE: if(Go == 1) register_A <= {5'd0, Dividend[3:0]}; //starts with register A set to 0
			S_BITCHECK: begin end //irrelevant, nothing happens
			S_SHIFT: next_register_A[8:0] <= register_A[8:0] << 1; //dividend is shifted left by 1 bit
			S_SUB: next_register_A[8:0] <= {register_A[8:4] - Divisor[3:0], register_A[3:0]}; //the divisor is subtracted from register A
			S_ADD:
			begin
				next_bit_counter[2:0] <= current_bit_counter + 1'b1;
				next_register_A[8:0] <= (register_A[8] == 1'b1) ? ({register_A[8:4] + Divisor[3:0], register_A[3:1], 1'b0}) : ({register_A[8:1], 1'b1});
				// if msb of register a is a 1, then we add divisor to register A and set lsb to 0; otherwise, we set lsb of divident to 1
			end
			default: next_register_A = register_A;
		endcase
	end
	
	//current state registers
	always@(posedge Clock)
	begin
		if(!Resetn)
			begin
				current_state <= S_RESTORE; //reset state
				current_bit_counter <= 3'b0;
				register_A<= 9'b0;
			end
		else
			begin
				current_state <= next_state; //set current state to the current next state
				current_bit_counter <= next_bit_counter; //set current bit counter to the next bit counter
				register_A[8:0] <= next_register_A; //set 9 bits of remainder quotient to the current remainder quotient next
			end
	end

	
	assign Quotient[3:0] = register_A[3:0]; //extract portion of register_A that is the actual quotient
	assign Remainder[3:0] = register_A[8:4]; //extract portion of register_A that is the actual remainder
	
endmodule