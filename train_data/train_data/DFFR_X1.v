module DFFR_X1 (D, CK, RN, Q, QN);
  input D, CK, RN;
  output Q, QN;
  assign Q = D & CK & ~RN;
  assign QN = ~Q;
endmodule