module f6_TECH_NOR4(input [3:0] in, output out);
assign out = ~(|in);
endmodule