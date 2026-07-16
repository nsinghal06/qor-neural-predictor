//465
module sync_counter (
	CK, 
	EN,
	RST,
	Q
);
	
	input CK;
	input EN;
	input RST;
	output [3:0] Q;
	
	reg [3:0] Q;
	
	always @(posedge CK) begin
		if (RST == 1) begin
			Q <= 4'b0000;
		end else if (EN == 1) begin
			Q <= Q + 1;
		end
	end
	
endmodule