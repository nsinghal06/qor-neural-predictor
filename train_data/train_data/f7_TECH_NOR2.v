module f7_TECH_NOR2(input [1:0] in, output out);
assign out = ~(|in);
endmodule