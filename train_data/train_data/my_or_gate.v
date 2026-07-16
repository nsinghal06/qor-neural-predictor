//1122
module my_or_gate (
    input A,
    input B,
    input C_N,
    output X,
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);

wire AB, ABC_N;

assign AB = A | B;
assign ABC_N = AB | C_N;
assign X = ABC_N;

or3b_4 base (
    .X(X),
    .A(A),
    .B(B),
    .C(C_N),
    .VPWR(VPWR),
    .VGND(VGND),
    .VPB(VPB),
    .VNB(VNB)
);

endmodule

module or3b_4 (
    input X,
    input A,
    input B,
    input C,
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);

endmodule