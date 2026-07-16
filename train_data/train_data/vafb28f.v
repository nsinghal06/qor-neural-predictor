module vafb28f (
 input [3:0] v515fe7,
 input [3:0] v3c88fc,
 output [7:0] va9ac17
);
 wire [0:7] w0;
 wire [0:3] w1;
 wire [0:3] w2;
 assign va9ac17 = w0;
 assign w1 = v515fe7;
 assign w2 = v3c88fc;
 vafb28f_v9a2a06 v9a2a06 (
  .o(w0),
  .i1(w1),
  .i0(w2)
 );
endmodule