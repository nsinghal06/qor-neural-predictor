//56
module b2d(SW,HEX0,HEX1,HEX2,HEX3);

	// Input Port(s)
	input [17:0] SW;
	
	// Output Port(s)
	output [0:6] HEX0,HEX1,HEX2,HEX3;
	
	// Instantiate b2d_7seg modules for each segment of SW
	b2d_7seg B0 (SW[3:0], HEX0);
	b2d_7seg B1 (SW[7:4], HEX1);
	b2d_7seg B2 (SW[11:8], HEX2);
	b2d_7seg B3 (SW[15:12], HEX3);

endmodule

module b2d_7seg(bin, seg);
	// Input Port(s)
	input [3:0] bin;
	
	// Output Port(s)
	output [6:0] seg;
	
	// Mapping of decimal digits to 7-segment display segments
	assign seg = (bin == 4'd0) ? 7'b0111111 :
	             (bin == 4'd1) ? 7'b0000110 :
	             (bin == 4'd2) ? 7'b1011011 :
	             (bin == 4'd3) ? 7'b1001111 :
	             (bin == 4'd4) ? 7'b1100110 :
	             (bin == 4'd5) ? 7'b1101101 :
	             (bin == 4'd6) ? 7'b1111101 :
	             (bin == 4'd7) ? 7'b0000111 :
	             (bin == 4'd8) ? 7'b1111111 :
	             (bin == 4'd9) ? 7'b1101111 : 7'b1110111;
	
endmodule