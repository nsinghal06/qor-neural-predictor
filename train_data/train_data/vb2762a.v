module vb2762a (
 input [7:0] v715730,
 input [7:0] vf191e6,
 output v4642b6
);
 wire w0;
 wire w1;
 wire w2;
 wire [0:7] w3;
 wire [0:7] w4;
 wire [0:3] w5;
 wire [0:3] w6;
 wire [0:3] w7;
 wire [0:3] w8;
 assign v4642b6 = w0;
 assign w3 = v715730;
 assign w4 = vf191e6;
 v438230 v577a36 (
  .v4642b6(w2),
  .v693354(w6),
  .v5369cd(w8)
 );
 vba518e v707c6e (
  .vcbab45(w0),
  .v0e28cb(w1),
  .v3ca442(w2)
 );
 v6bdcd9 v921a9f (
  .vcc8c7c(w4),
  .v651522(w7),
  .v2cc41f(w8)
 );
 v6bdcd9 v8cfa4d (
  .vcc8c7c(w3),
  .v651522(w5),
  .v2cc41f(w6)
 );
 v438230 vfc1765 (
  .v4642b6(w1),
  .v693354(w5),
  .v5369cd(w7)
 );
endmodule