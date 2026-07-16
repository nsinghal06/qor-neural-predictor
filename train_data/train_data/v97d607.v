module v97d607 (
 input v6dda25,
 input ve556f1,
 output [23:0] v9e1c43,
 output ve37344
);
 wire w0;
 wire [0:23] w1;
 wire [0:23] w2;
 wire w3;
 wire [0:23] w4;
 wire w5;
 assign w0 = ve556f1;
 assign w3 = v6dda25;
 assign v9e1c43 = w4;
 assign ve37344 = w5;
 assign w4 = w1;
 v5495b5 v5e4c9c (
  .v782748(w0),
  .vb02eea(w1),
  .v15c6e6(w2),
  .v6dda25(w3)
 );
 v9c4559 v62e821 (
  .v005b83(w1),
  .v53d485(w2),
  .v4642b6(w5)
 );
endmodule