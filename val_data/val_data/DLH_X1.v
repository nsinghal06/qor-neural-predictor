module DLH_X1 (G, D, Q);
  input G, D;
  output Q;
  assign Q = G & D;
endmodule