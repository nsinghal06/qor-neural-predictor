module f5_TECH_NAND18(input [17:0] in, output out);
assign out = ~(&in);
endmodule