//1161
module sky130_fd_sc_ms__nand4 (
    Y   ,
    A   ,
    B   ,
    C   ,
    D   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Y   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    wire y1;
    wire y2;

    nand (y1, A, B);

    nand (y2, C, D);

    nand (Y, y1, y2);

endmodule