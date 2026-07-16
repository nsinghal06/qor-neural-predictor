module multiplier_16bit (
    input [15:0] in0,
    input [15:0] in1,
    output [31:0] result
);

assign result = in0 * in1;

endmodule