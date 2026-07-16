module PED (D, Clk, Q);
	
	input D, Clk;
	output reg Q;

	always @ (posedge Clk)
		
		Q = D;
	
endmodule