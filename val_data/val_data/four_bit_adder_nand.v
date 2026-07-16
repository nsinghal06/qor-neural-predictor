//335
module four_bit_adder_nand(
  input [3:0] A,
  input [3:0] B,
  output [3:0] S,
  output Cout
);

  wire [3:0] X, Y, Z, C1, C2, C3;
  nand (X[0], A[0], B[0]);
  nand (X[1], A[1], B[1]);
  nand (X[2], A[2], B[2]);
  nand (X[3], A[3], B[3]);

  nand (Y[0], X[0], X[1]);
  nand (Y[1], X[2], X[3]);

  nand (Z[0], Y[0], Y[1]);
  nand (Z[1], Y[0], C1[1]);
  nand (Z[2], Y[1], C1[2]);
  nand (Z[3], C1[3], C2[1]);

  nand (C1[0], A[0], B[0]);
  nand (C1[1], A[1], B[1]);
  nand (C1[2], A[2], B[2]);
  nand (C1[3], A[3], B[3]);

  nand (C2[0], X[0], X[1]);
  nand (C2[1], X[2], X[3]);

  nand (C3[0], Y[0], Y[1]);

  nand (Cout, C1[3], C2[1], C3[0]);

  assign S = Z;

endmodule