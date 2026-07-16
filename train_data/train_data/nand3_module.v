module nand3_module (
    input A,
    input B,
    input C,
    output Y
);

wire nand_AB, nand_Y;

nand2 nand1 (
    .A(A),
    .B(B),
    .Y(nand_AB)
);

nand2 nand2 (
    .A(nand_AB),
    .B(C),
    .Y(nand_Y)
);

assign Y = nand_Y;

endmodule