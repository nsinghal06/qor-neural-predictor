module v438230 (
 input [3:0] v693354,
 input [3:0] v5369cd,
 output v4642b6
);
 wire w0;
 wire [0:3] w1;
 wire [0:3] w2;
 wire w3;
 wire w4;
 wire w5;
 wire w6;
 wire w7;
 wire w8;
 wire w9;
 wire w10;
 wire w11;
 wire w12;
 wire w13;
 wire w14;
 assign v4642b6 = w0;
 assign w1 = v693354;
 assign w2 = v5369cd;
 v23b15b v09a5a5 (
  .v4642b6(w3),
  .v27dec4(w12),
  .v6848e9(w14)
 );
 v23b15b vc1b29d (
  .v4642b6(w4),
  .v27dec4(w11),
  .v6848e9(w13)
 );
 v23b15b vcd27ce (
  .v4642b6(w5),
  .v27dec4(w9),
  .v6848e9(w10)
 );
 vc4f23a vea9c80 (
  .v985fcb(w1),
  .v4f1fd3(w7),
  .vda577d(w9),
  .v3f8943(w11),
  .v64d863(w12)
 );
 vc4f23a va7dcdc (
  .v985fcb(w2),
  .v4f1fd3(w8),
  .vda577d(w10),
  .v3f8943(w13),
  .v64d863(w14)
 );
 v23b15b va0849c (
  .v4642b6(w6),
  .v27dec4(w7),
  .v6848e9(w8)
 );
 veffd42 v6e3e65 (
  .vcbab45(w0),
  .v3ca442(w3),
  .v0e28cb(w4),
  .v033bf6(w5),
  .v9eb652(w6)
 );
endmodule