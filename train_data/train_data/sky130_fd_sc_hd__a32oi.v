//199
module sky130_fd_sc_hd__a32oi (
    output Y   ,
    input  A1  ,
    input  A2  ,
    input  A3  ,
    input  B1  ,
    input  B2  ,
    input  VPWR,
    input  VGND,
    input  VPB ,
    input  VNB
);

    // Module ports
    //output Y   ;
    //input  A1  ;
    //input  A2  ;
    //input  A3  ;
    //input  B1  ;
    //input  B2  ;
    //input  VPWR;
    //input  VGND;
    //input  VPB ;
    //input  VNB ;

    // Local signals
    wire nand0_out        ;
    wire nand1_out        ;
    wire and0_out_Y       ;
    wire pwrgood_pp0_out_Y;

    //                                 Name         Output             Other arguments
    nand                               nand0       (nand0_out        , A2, A1, A3            );
    nand                               nand1       (nand1_out        , B2, B1                );
    and                                and0        (and0_out_Y       , nand0_out, nand1_out  );
    //sky130_fd_sc_hd__udp_pwrgood_pp$PG pwrgood_pp0 (pwrgood_pp0_out_Y, and0_out_Y, VPWR, VGND);
    buf                                buf0        (Y                , and0_out_Y             );

endmodule