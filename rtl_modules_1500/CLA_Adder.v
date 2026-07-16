//348
module CLA_Adder (
  input [3:0] A,
  input [3:0] B,
  input Operation,
  output [3:0] Sum,
  output Error
    );
    
  // Generate and propagate signals
  wire [2:0] G;
  wire [2:0] P;
  wire [3:0] Cin;
  assign G[0] = A[0] & (B[0] ^ Operation);
  assign P[0] = A[0] ^ (B[0] ^ Operation);

  assign G[1] = A[1] & (B[1] ^ Operation);
  assign P[1] = A[1] ^ (B[1] ^ Operation);
  
  assign G[2] = A[2] & (B[2] ^ Operation);
  assign P[2] = A[2] ^ (B[2] ^ Operation);

  assign Cin[0] = Operation;
  assign Cin[1] = G[0] | P[0] & Operation;
  assign Cin[2] = G[1] | P[1] & (G[0] | P[0] & Operation);
  assign Cin[3] = G[2] | P[2] & (G[1] | P[1] & (G[0] | P[0] & Operation));

  // Implement adder slices
 AdderSlice Part1 (
  .A(A[0]),
  .B(B[0] ^ Operation),
  .Cin(Cin[0]),
  .S(Sum[0])
 );

 AdderSlice Part2 (
  .A(A[1]),
  .B(B[1] ^ Operation),
  .Cin(Cin[1]),
  .S(Sum[1])
 );

 AdderSlice Part3 (
  .A(A[2]),
  .B(B[2] ^ Operation),
  .Cin(Cin[2]),
  .S(Sum[2])
 );

 AdderSlice Part4 (
  .A(A[3]),
  .B(B[3] ^ Operation),
  .Cin(Cin[3]),
  .S(Sum[3])
 );

 // Implement error detection
 ErrorDetection Part (
     .A_MSB(A[3]),
     .B_MSB(B[3]),
     .Operation(Operation),
     .S_MSB(Sum[3]),
     .Error(Error)
  );
  
endmodule

module AdderSlice (
  input A,
  input B,
  input Cin,
  output S
  );
  
  wire T1;
  wire C1;
  wire C2;
  
  FullAdder F1 (
    .A(A),
    .B(B),
    .Cin(Cin),
    .Cout(C1),
    .S(T1)
  );
  
  FullAdder F2 (
    .A(T1),
    .B(Cin),
    .Cin(C1),
    .Cout(C2),
    .S(S)
  );
  
endmodule

module FullAdder (
  input A,
  input B,
  input Cin,
  output Cout,
  output S
  );
  
  wire C1;
  wire C2;
  
  assign C1 = A & B;
  assign C2 = A ^ B;
  assign S = C2 ^ Cin;
  assign Cout = C1 | (C2 & Cin);
  
endmodule

module ErrorDetection (
  input A_MSB,
  input B_MSB,
  input Operation,
  input S_MSB,
  output Error
  );
  
  assign Error = (A_MSB == B_MSB) && (A_MSB != S_MSB) && (Operation == 0);
  
endmodule