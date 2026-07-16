//1279
module full_adder_4bit ( A, B, Ci, S, Co );
  input [3:0] A, B;
  input Ci;
  output [3:0] S;
  output Co;
  wire [3:0] Cin, Cout;

  assign Cin[0] = Ci;
  assign S[0] = A[0] ^ B[0] ^ Ci;
  assign Cout[0] = (A[0] & B[0]) | (Ci & (A[0] | B[0]));
  
  assign Cin[1] = Cout[0];
  assign S[1] = A[1] ^ B[1] ^ Cin[1];
  assign Cout[1] = (A[1] & B[1]) | (Cin[1] & (A[1] | B[1]));
  
  assign Cin[2] = Cout[1];
  assign S[2] = A[2] ^ B[2] ^ Cin[2];
  assign Cout[2] = (A[2] & B[2]) | (Cin[2] & (A[2] | B[2]));
  
  assign Cin[3] = Cout[2];
  assign S[3] = A[3] ^ B[3] ^ Cin[3];
  assign Cout[3] = (A[3] & B[3]) | (Cin[3] & (A[3] | B[3]));
  
  assign Co = Cout[3];
endmodule