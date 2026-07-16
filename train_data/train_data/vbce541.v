module vbce541 #(
 parameter va04f5d = 16777216
) (
 input v6dda25,
 output v4642b6
);
 localparam p1 = va04f5d;
 wire w0;
 wire [0:23] w2;
 wire [0:23] w3;
 wire w4;
 wire w5;
 assign v4642b6 = w0;
 assign w5 = v6dda25;
 assign w4 = w0;
 vef98b5 #(
  .vc5c8ea(p1)
 ) v4016e8 (
  .ve70c2d(w3)
 );
 vd84ae0 v45b714 (
  .v4642b6(w0),
  .va89056(w2),
  .v06bdfb(w3)
 );
 v97d607 v2299cf (
  .v9e1c43(w2),
  .ve556f1(w4),
  .v6dda25(w5)
 );
endmodule