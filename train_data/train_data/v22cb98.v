module v22cb98 #(
 parameter v5462c0 = 0
) (
 input ve4a668,
 input v27dec4,
 input vd793aa,
 output v4642b6
);
 localparam p1 = v5462c0;
 wire w0;
 wire w2;
 wire w3;
 wire w4;
 wire w5;
 wire w6;
 assign w2 = ve4a668;
 assign w3 = v27dec4;
 assign v4642b6 = w5;
 assign w6 = vd793aa;
 assign w5 = w4;
 va40d2f v9ff767 (
  .v030ad0(w0),
  .vb192d0(w3),
  .v27dec4(w4),
  .v2d3366(w6)
 );
 v053dc2 #(
  .v71e305(p1)
 ) v89c757 (
  .vf54559(w0),
  .va4102a(w2),
  .ve8318d(w4)
 );
endmodule