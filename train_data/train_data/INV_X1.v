module INV_X1 (A, ZN);
  input A;
  output ZN;
  assign ZN = ~A;
endmodule