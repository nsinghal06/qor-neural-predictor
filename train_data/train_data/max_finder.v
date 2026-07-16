module max_finder (
    input [3:0] a,
    input [3:0] b,
    output [3:0] max_val
);

    assign max_val = (a > b) ? a : b;

endmodule