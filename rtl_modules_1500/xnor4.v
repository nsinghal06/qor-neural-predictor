//293
module xnor4 (
    Y,
    A,
    B
);

    output [3:0] Y;
    input  [3:0] A;
    input  [3:0] B;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    xnor2 xnor0 (.Y(Y[0]), .A(A[0]), .B(B[0]));
    xnor2 xnor1 (.Y(Y[1]), .A(A[1]), .B(B[1]));
    xnor2 xnor2 (.Y(Y[2]), .A(A[2]), .B(B[2]));
    xnor2 xnor3 (.Y(Y[3]), .A(A[3]), .B(B[3]));

endmodule

module xnor2 (
    Y,
    A,
    B
);

    output Y;
    input  A;
    input  B;

    assign Y = !(A ^ B);

endmodule