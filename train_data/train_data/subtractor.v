module subtractor (
    input [3:0] in,
    output [3:0] out
);

// Subtract 4'b0101 from the input
assign out = in - 4'b0101;

endmodule