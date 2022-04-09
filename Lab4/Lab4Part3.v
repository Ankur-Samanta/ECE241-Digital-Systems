module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
	input clock, reset, ParallelLoadn, RotateRight, ASRight;
	input [7:0] Data_IN;
	output [7:0] Q;
	wire w;
	
	//mux2to1 m1(Q[7], Q[0], ASRight, w); //assignment for w
	assign w = ASRight ? Q[0] : Q[7];
	//8 rotating register calls
	rotatingRegister R1(w, Q[1], RotateRight, Data_IN[7], ParallelLoadn, clock, reset, Q[7]);
	rotatingRegister R2(Q[0], Q[2], RotateRight, Data_IN[6], ParallelLoadn, clock, reset, Q[6]);
	rotatingRegister R3(Q[1], Q[3], RotateRight, Data_IN[5], ParallelLoadn, clock, reset, Q[5]);
	rotatingRegister R4(Q[2], Q[4], RotateRight, Data_IN[4], ParallelLoadn, clock, reset, Q[4]);
	rotatingRegister R5(Q[3], Q[5], RotateRight, Data_IN[3], ParallelLoadn, clock, reset, Q[3]);
	rotatingRegister R6(Q[4], Q[6], RotateRight, Data_IN[2], ParallelLoadn, clock, reset, Q[2]);
	rotatingRegister R7(Q[5], Q[7], RotateRight, Data_IN[1], ParallelLoadn, clock, reset, Q[1]);
	rotatingRegister R8(Q[6], Q[0], RotateRight, Data_IN[0], ParallelLoadn, clock, reset, Q[0]);
	
endmodule

module rotatingRegister(right, left, LoadLeft, D, loadn, clock, reset, Q);
	input right, left, LoadLeft, D, loadn, clock, reset;
	output Q;
	wire w1, w2;
	
	//mux2to1 m1(left, right, LoadLeft, w1);
	assign w1 = LoadLeft ? right : left;
	//mux2to1 m2(D, w1, loadn, w2);
	assign w2 = loadn ? w1 : D;
	flipflop f1(w2, clock, reset, Q);
endmodule
	
module mux2to1(x, y, s, m); //init
	input x, y, s; //input
	output m; //output
	wire w1, w2, w3; // wires
	
	v7404 g1(.pin1(s), .pin2(w1)); //gate1(not)
	v7408 g2(.pin1(x), .pin2(w1), .pin3(w2), .pin4(y), .pin5(s), .pin6(w3)); //gate2(and)
	v7432 g3(.pin1(w2), .pin2(w3), .pin3(m)); //gate3(or)
	
endmodule //2-1 multiplexer
	
module v7404 (
	pin1, pin3, pin5, pin9, pin11, pin13,
	pin2, pin4, pin6, pin8, pin10, pin12); //init
	
	input pin1, pin3, pin5, pin9, pin11, pin13; //input
	output pin2, pin4, pin6, pin8, pin10, pin12; //output
	
	assign pin2 = ~pin1; //pin2 = not pin1
	assign pin4 = ~pin3; //pin4 = not pin3
	assign pin6 = ~pin5; //pin6 = not pin5
	assign pin8 = ~pin9; //pin8 = not pin9
	assign pin10 = ~pin11; //pin10 = not pin11
	assign pin12 = ~pin13; //pin12 = not pin13
	
endmodule //v7404 not gate

module v7408 (
	pin1, pin3, pin5, pin9, pin11, pin13,
	pin2, pin4, pin6, pin8, pin10, pin12); //init
	
	input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13; //input pins
	output pin3, pin6, pin8, pin11; //output pins
	
	assign pin3 = (pin1 & pin2); //pin3 = pin1 and pin2
	assign pin6 = (pin4 & pin5); //pin6 = pin4 and pin5
	assign pin8 = (pin9 & pin10); //pin8 = pin9 and pin10
	assign pin11 = (pin12 & pin13); //pin11 = pin12 and pin13
	
endmodule //v7408 and gate

module v7432 (
	pin1, pin3, pin5, pin9, pin11, pin13,
	pin2, pin4, pin6, pin8, pin10, pin12); //init
	
	input pin1, pin2, pin4, pin5, pin9, pin10, pin12, pin13; //input pins
	output pin3, pin6, pin8, pin11; //output pins
	
	assign pin3 = (pin1 | pin2); //pin3 = pin1 or pin2
	assign pin6 = (pin4 | pin5); //pin6 = pin4 or pin5
	assign pin8 = (pin9 | pin10); //pin8 = pin9 or pin10
	assign pin11 = (pin12 | pin13); //pin11 = pin12 or pin13
	
endmodule //v7432 or gate

module flipflop(D, clock, reset, Q);
	input D, clock, reset;
	output reg Q;
	
	always@(posedge clock)
	begin
		if (reset == 1'b1) //active high reset
			Q <= 0;
		else
			Q <= D;
	end
	
endmodule
