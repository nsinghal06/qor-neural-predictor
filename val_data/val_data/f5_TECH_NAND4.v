module f5_TECH_NAND4(input [3:0] in, output out);
assign out = ~(&in);
endmodule