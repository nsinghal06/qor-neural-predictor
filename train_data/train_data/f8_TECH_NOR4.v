module f8_TECH_NOR4(input [3:0] in, output out);
assign out = ~(|in);
endmodule