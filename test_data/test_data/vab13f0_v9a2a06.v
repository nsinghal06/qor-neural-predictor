module vab13f0_v9a2a06 (
 input [23:0] i,
 output [15:0] o1,
 output [7:0] o0
);
 assign o1 = i[23:8];
 assign o0 = i[7:0];
endmodule