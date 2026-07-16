module vcb23aa (
 input [7:0] v39966a,
 input [7:0] veb2f59,
 output v4642b6,
 output [7:0] v62bf25
);
 wire [0:7] w0;
 wire [0:7] w1;
 wire [0:3] w2;
 wire [0:3] w3;
 wire [0:7] w4;
 wire w5;
 wire w6;
 wire [0:3] w7;
 wire [0:3] w8;
 wire [0:3] w9;
 wire [0:3] w10;
 assign w0 = veb2f59;
 assign w1 = v39966a;
 assign v62bf25 = w4;
 assign v4642b6 = w5;
 v6bdcd9 vd88c66 (
  .vcc8c7c(w0),
  .v651522(w9),
  .v2cc41f(w10)
 );
 v6bdcd9 v26a0bb (
  .vcc8c7c(w1),
  .v651522(w7),
  .v2cc41f(w8)
 );
 v25966b v9ea427 (
  .v817794(w3),
  .v4642b6(w6),
  .v0550b6(w8),
  .v24708e(w10)
 );
 vafb28f vc75346 (
  .v515fe7(w2),
  .v3c88fc(w3),
  .va9ac17(w4)
 );
 va1ce30 v40c17f (
  .v817794(w2),
  .v4642b6(w5),
  .vb9cfc3(w6),
  .v0550b6(w7),
  .v24708e(w9)
 );
endmodule