module logical_or(
    input [2:0] a,
    input [2:0] b,
    output out
);
    assign out = (a != 0) || (b != 0);
endmodule