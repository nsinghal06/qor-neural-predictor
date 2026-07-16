module v6fef69 (
 input [23:0] v9804b7,
 output [7:0] vd83cb2,
 output [7:0] v243fb2,
 output [7:0] va2a3a1
);
 wire [0:7] w0;
 wire [0:7] w1;
 wire [0:7] w2;
 wire [0:23] w3;
 assign v243fb2 = w0;
 assign vd83cb2 = w1;
 assign va2a3a1 = w2;
 assign w3 = v9804b7;
 v6fef69_v9a2a06 v9a2a06 (
  .o1(w0),
  .o2(w1),
  .o0(w2),
  .i(w3)
 );
endmodule