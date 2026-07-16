//1175
module Adder4(S, Cout, A, B, Cin);
  output [3:0] S;
  output Cout;
  input [3:0] A, B;
  input Cin;

  wire [3:0] sum;
  wire int_0n, int_1n;

  // Full adder for the least significant bit
  FullAdder FA0 (sum[0], int_0n, A[0], B[0], Cin);

  // Full adder for the remaining bits
  FullAdder FA1 (sum[1], int_1n, A[1], B[1], int_0n);
  FullAdder FA2 (sum[2], Cout, A[2], B[2], int_1n);
  FullAdder FA3 (sum[3], , A[3], B[3], Cout);

  assign S = sum;
  assign Cout = Cout;

endmodule

module FullAdder(S, Cout, A, B, Cin);
  output S, Cout;
  input A, B, Cin;

  wire int_0n, int_1n;

  // XOR gate
  xor (int_0n, A, B);

  // AND gate
  and (int_1n, A, B);

  // AND gate
  and (Cout, int_0n, Cin);

  // OR gate
  or (S, int_0n, Cin);

endmodule