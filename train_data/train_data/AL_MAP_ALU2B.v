module AL_MAP_ALU2B (
   input cin,
   input a0, b0, c0, d0,
   input a1, b1, c1, d1,
   output s0, s1, cout
);
	parameter [15:0] INIT0 = 16'h0000;
	parameter [15:0] INIT1 = 16'h0000;
	parameter FUNC0 = "NO";
	parameter FUNC1 = "NO";
endmodule