module signed_mag_comparator (
    input signed [3:0] A,
    output eq,
    output lt,
    output gt
);
    assign eq = (A == 0);
    assign lt = (A < 0);
    assign gt = (A > 0);
endmodule