//1127
module sky130_fd_sc_hd__o311a (
    X ,
    A1,
    A2,
    A3,
    B1,
    C1
);

    output X ;
    input  A1;
    input  A2;
    input  A3;
    input  B1;
    input  C1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;
    
    // Implement the circuit
    assign X = (A1 & A2 & A3) | (B1 & C1);

endmodule