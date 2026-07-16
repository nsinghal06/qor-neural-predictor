module vc3c498 (
 input [7:0] v45c6ee,
 input [7:0] v20212e,
 input vb9cfc3,
 output v4642b6,
 output [7:0] veeaa8e
);
 wire w0;
 wire w1;
 wire [0:7] w2;
 wire [0:7] w3;
 wire [0:7] w4;
 wire [0:3] w5;
 wire [0:3] w6;
 wire w7;
 wire [0:3] w8;
 wire [0:3] w9;
 wire [0:3] w10;
 wire [0:3] w11;
 assign w1 = vb9cfc3;
 assign w2 = v45c6ee;
 assign w3 = v20212e;
 assign veeaa8e = w4;
 assign v4642b6 = w7;
 v6bdcd9 v8d795a (
  .vcc8c7c(w3),
  .v651522(w10),
  .v2cc41f(w11)
 );
 v6bdcd9 v23dbc5 (
  .vcc8c7c(w2),
  .v651522(w8),
  .v2cc41f(w9)
 );
 vafb28f vef3a58 (
  .va9ac17(w4),
  .v3c88fc(w5),
  .v515fe7(w6)
 );
 va1ce30 v0ff71a (
  .v4642b6(w0),
  .vb9cfc3(w1),
  .v817794(w5),
  .v0550b6(w9),
  .v24708e(w11)
 );
 va1ce30 v12f94f (
  .vb9cfc3(w0),
  .v817794(w6),
  .v4642b6(w7),
  .v0550b6(w8),
  .v24708e(w10)
 );
endmodule