//409
module lab3_part4 (D, Clk, Qa, Qb, Qc);

	input D, Clk;
	output Qa, Qb, Qc;
		
	wire D, Clk;

	Dflop D0 (D, Clk, Qa);
	PED P0 (D, Clk, Qb);
	NED N0 (D, Clk, Qc);
	
	
	
endmodule

module NED (D, Clk, Q);
	
	input D, Clk;
	output reg Q;

	always @ (negedge Clk)
		
		Q = D;
		
endmodule

module PED (D, Clk, Q);
	
	input D, Clk;
	output reg Q;

	always @ (posedge Clk)
		
		Q = D;
	
endmodule

module Dflop (D, Clk, Q);
  input D, Clk;
  output reg Q;

  always @ (D, Clk)
	if (Clk)
		Q = D;
		
endmodule