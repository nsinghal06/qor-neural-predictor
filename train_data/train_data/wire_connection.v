module wire_connection (
    input a,b,c,
    output wire w,x,y,z
);

assign w = a & b;
assign x = a | b;
assign y = c ^ b;
assign z = ~(a & c);

endmodule