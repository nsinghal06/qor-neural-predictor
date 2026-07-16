module RAT_slice_12_8_0(
  input [17:0] Din,
  output [4:0] Dout
);

  wire [4:0] Dout_internal;
  assign Dout_internal[4] = Din[17];
  assign Dout_internal[3] = Din[16];
  assign Dout_internal[2] = Din[15];
  assign Dout_internal[1] = Din[14];
  assign Dout_internal[0] = Din[13];
  assign Dout = Dout_internal;

endmodule