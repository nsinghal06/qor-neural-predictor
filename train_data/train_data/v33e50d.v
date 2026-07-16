module v33e50d (
 input [7:0] vba04ee,
 input [7:0] vf7d213,
 input [7:0] v77c6e9,
 output [23:0] v6d326e
);
 wire [0:23] w0;
 wire [0:7] w1;
 wire [0:7] w2;
 wire [0:7] w3;
 assign v6d326e = w0;
 assign w1 = vf7d213;
 assign w2 = v77c6e9;
 assign w3 = vba04ee;
 v33e50d_v9a2a06 v9a2a06 (
  .o(w0),
  .i1(w1),
  .i0(w2),
  .i2(w3)
 );
endmodule