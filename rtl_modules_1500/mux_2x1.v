//276
module mux_2x1 (
  input [19:0] Q,
  input Q_reg,
  output [19:0] D
);

  wire [19:0] D_lut;

  assign D_lut[0] = Q_reg ? Q[0] : 0;
  assign D_lut[1] = Q_reg ? Q[1] : 0;
  assign D_lut[2] = Q_reg ? Q[2] : 0;
  assign D_lut[3] = Q_reg ? Q[3] : 0;
  assign D_lut[4] = Q_reg ? Q[4] : 0;
  assign D_lut[5] = Q_reg ? Q[5] : 0;
  assign D_lut[6] = Q_reg ? Q[6] : 0;
  assign D_lut[7] = Q_reg ? Q[7] : 0;
  assign D_lut[8] = Q_reg ? Q[8] : 0;
  assign D_lut[9] = Q_reg ? Q[9] : 0;
  assign D_lut[10] = Q_reg ? Q[10] : 0;
  assign D_lut[11] = Q_reg ? Q[11] : 0;
  assign D_lut[12] = Q_reg ? Q[12] : 0;
  assign D_lut[13] = Q_reg ? Q[13] : 0;
  assign D_lut[14] = Q_reg ? Q[14] : 0;
  assign D_lut[15] = Q_reg ? Q[15] : 0;
  assign D_lut[16] = Q_reg ? Q[16] : 0;
  assign D_lut[17] = Q_reg ? Q[17] : 0;
  assign D_lut[18] = Q_reg ? Q[18] : 0;
  assign D_lut[19] = Q_reg ? Q[19] : 0;

  assign D = Q_reg ? D_lut : 0;

endmodule