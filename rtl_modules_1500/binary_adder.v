//1439
module binary_adder (A, B, Ci, S, Co);
  input [3:0] A, B;
  input Ci;
  output [3:0] S;
  output Co;

  wire [3:0] X, Y, Z;

  // XOR gates for sum bits
  xor (X[0], A[0], B[0]);
  xor (X[1], A[1], B[1]);
  xor (X[2], A[2], B[2]);
  xor (X[3], A[3], B[3]);

  // AND gates for carry-out
  and (Y[0], A[0], B[0]);
  and (Y[1], A[1], B[1]);
  and (Y[2], A[2], B[2]);
  and (Y[3], A[3], B[3]);

  // XOR gates for carry-in and carry-out
  xor (Z[0], Y[0], Ci);
  xor (Z[1], Y[1], Z[0]);
  xor (Z[2], Y[2], Z[1]);
  xor (Co, Y[3], Z[2]);

  assign S = X;

endmodule