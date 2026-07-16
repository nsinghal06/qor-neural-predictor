//1227
module sky130_fd_sc_hd__a32o (
    X   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    B2  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    // Module ports
    output X   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  B2  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    // Local signals
    wire and0_out         ;
    wire and1_out         ;
    wire or0_out_X        ;

    //                                 Name         Output             Other arguments
    and                                and0        (and0_out         , A3, A1, A2           );
    and                                and1        (and1_out         , B1, B2               );
    or                                 or0         (or0_out_X        , and1_out, and0_out   );
    buf                                buf0        (X                , or0_out_X            );

endmodule