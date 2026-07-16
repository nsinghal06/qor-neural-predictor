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