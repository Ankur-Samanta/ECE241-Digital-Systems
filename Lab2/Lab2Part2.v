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