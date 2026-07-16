module OAI21_X1 (B1, B2, A, ZN);
  input B1, B2, A;
  output ZN;
  assign ZN = ~(B1 & B2) & A;
endmodule