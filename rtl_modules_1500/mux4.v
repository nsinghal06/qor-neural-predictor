//1109
module MUX4
(
  A,
  B,
  C,
  D,
  S0,
  S1,
  Z
);

  input A, B, C, D, S0, S1;
  output Z;

  wire not_S0, not_S1;

  assign not_S0 = ~S0;
  assign not_S1 = ~S1;

  assign Z = (A & not_S0 & not_S1) | (B & not_S0 & S1) | (C & S0 & not_S1) | (D & S0 & S1);

endmodule