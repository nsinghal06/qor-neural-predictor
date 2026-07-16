module vbef3fc #(
 parameter v8bcde4 = 0
) (
 input v6dda25,
 input v3dc29f,
 output v4642b6
);
 localparam p1 = v8bcde4;
 wire w0;
 wire w2;
 wire w3;
 wire w4;
 wire w5;
 assign w2 = v3dc29f;
 assign w3 = v6dda25;
 assign v4642b6 = w4;
 assign w5 = w4;
 v3676a0 vdebd76 (
  .vcbab45(w0),
  .v0e28cb(w5)
 );
 v22cb98 #(
  .v5462c0(p1)
 ) v51de32 (
  .v27dec4(w0),
  .vd793aa(w2),
  .ve4a668(w3),
  .v4642b6(w4)
 );
endmodule