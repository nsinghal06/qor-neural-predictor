//670
module sky130_fd_sc_hd__o2bb2ai (
    Y   ,
    A1_N,
    A2_N,
    B1  ,
    B2
);

    output Y   ;
    input  A1_N;
    input  A2_N;
    input  B1  ;
    input  B2  ;

    // Logic to generate Y
    assign Y = (A1_N & ~A2_N) ? B1 : ((~A1_N) & A2_N) ? B2 : (A1_N & A2_N) ? 1'b0 : 1'b1;

endmodule

module sky130_fd_sc_hd__o2bb2ai_2 (
    Y   ,
    A1_N,
    A2_N,
    B1  ,
    B2
);

    output Y   ;
    input  A1_N;
    input  A2_N;
    input  B1  ;
    input  B2  ;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    sky130_fd_sc_hd__o2bb2ai base (
        .Y(Y),
        .A1_N(A1_N),
        .A2_N(A2_N),
        .B1(B1),
        .B2(B2)
    );

endmodule