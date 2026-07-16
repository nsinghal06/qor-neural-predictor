//322
module enable_sky130_fd_sc_hd__dlrtn (
    input enable,
    input RESET_B,
    input D,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Q,
    output out
);

    wire Q_wire;

    sky130_fd_sc_hd__dlrtn_1 dut (.RESET_B(RESET_B), .D(D), .VPWR(VPWR), .VGND(VGND), .VPB(VPB), .VNB(VNB), .Q(Q_wire));

    assign out = enable ? Q_wire : 1;

    assign Q = enable ? Q_wire : 1;

endmodule

module sky130_fd_sc_hd__dlrtn_1 (
    input RESET_B,
    input D,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Q
);

endmodule