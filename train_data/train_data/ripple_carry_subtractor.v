module ripple_carry_subtractor (
    input [99:0] a, b,
    output [99:0] diff
);

assign diff = a - b;

endmodule