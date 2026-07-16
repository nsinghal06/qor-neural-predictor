//363
module sky130_fd_sc_lp__inputiso1n (
    X      ,
    A      ,
    SLEEP_B
);

    // Module ports
    output X      ;
    input  A      ;
    input  SLEEP_B;

    // Local signals
    wire SLEEP    ;

    //                                 Name         Output     Other arguments
    not                                not0        (SLEEP    , SLEEP_B              );
    or                                 or0         (X, A, SLEEP             );

endmodule