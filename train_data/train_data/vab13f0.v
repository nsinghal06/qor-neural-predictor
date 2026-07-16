module vab13f0 (
 input [23:0] vb18564,
 output [15:0] vf0a06e,
 output [7:0] v5246f6
);
 wire [0:23] w0;
 wire [0:15] w1;
 wire [0:7] w2;
 assign w0 = vb18564;
 assign vf0a06e = w1;
 assign v5246f6 = w2;
 vab13f0_v9a2a06 v9a2a06 (
  .i(w0),
  .o1(w1),
  .o0(w2)
 );
endmodule