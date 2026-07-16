module vd84ae0 (
 input [23:0] v06bdfb,
 input [23:0] va89056,
 output v4642b6
);
 wire w0;
 wire w1;
 wire w2;
 wire w3;
 wire [0:23] w4;
 wire [0:23] w5;
 wire [0:7] w6;
 wire [0:7] w7;
 wire [0:7] w8;
 wire [0:7] w9;
 wire [0:7] w10;
 wire [0:7] w11;
 assign v4642b6 = w0;
 assign w4 = v06bdfb;
 assign w5 = va89056;
 vb2762a vb6832a (
  .v4642b6(w1),
  .v715730(w8),
  .vf191e6(w11)
 );
 vb2762a v302658 (
  .v4642b6(w2),
  .v715730(w7),
  .vf191e6(w10)
 );
 vae245c v9196c7 (
  .vcbab45(w0),
  .v3ca442(w1),
  .v0e28cb(w2),
  .v033bf6(w3)
 );
 v6fef69 vb1e577 (
  .v9804b7(w5),
  .vd83cb2(w9),
  .v243fb2(w10),
  .va2a3a1(w11)
 );
 v6fef69 v62b64f (
  .v9804b7(w4),
  .vd83cb2(w6),
  .v243fb2(w7),
  .va2a3a1(w8)
 );
 vb2762a v9a65c6 (
  .v4642b6(w3),
  .v715730(w6),
  .vf191e6(w9)
 );
endmodule