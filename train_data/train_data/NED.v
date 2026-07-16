module NED (D, Clk, Q);
	
	input D, Clk;
	output reg Q;

	always @ (negedge Clk)
		
		Q = D;
		
endmodule