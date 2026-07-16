module MUX2_X1 (A, B, S, Z);
  input A, B, S;
  output Z;
  assign Z = S ? B : A;
endmodule