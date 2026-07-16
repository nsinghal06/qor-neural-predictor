module threshold_module(
    input [99:0] in_and,
    input [99:0] in_or,
    input [99:0] in_xor,
    input threshold,
    output [99:0] final_out
);

    assign final_out = ((in_or & threshold) | (in_xor & ~threshold)) ^ (in_and & ~threshold) ;

endmodule