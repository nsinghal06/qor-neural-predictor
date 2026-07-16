module va52e3b (
 input [7:0] vf7d213,
 input [15:0] vbf8961,
 output [23:0] v6d326e
);
 wire [0:15] w0;
 wire [0:23] w1;
 wire [0:7] w2;
 assign w0 = vbf8961;
 assign v6d326e = w1;
 assign w2 = vf7d213;
 va52e3b_v9a2a06 v9a2a06 (
  .i0(w0),
  .o(w1),
  .i1(w2)
 );
endmodule