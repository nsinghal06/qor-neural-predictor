module NAND2_X1 (A1, A2, ZN);
  input A1, A2;
  output ZN;
  assign ZN = ~(A1 & A2);
endmodule