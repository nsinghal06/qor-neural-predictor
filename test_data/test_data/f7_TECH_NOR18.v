module f7_TECH_NOR18(input [17:0] in, output out);
assign out = ~(|in);
endmodule