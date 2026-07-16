module vc4f23a_v9a2a06 (
 input [3:0] i,
 output o3,
 output o2,
 output o1,
 output o0
);
 assign o3 = i[3];
 assign o2 = i[2];
 assign o1 = i[1];
 assign o0 = i[0];
endmodule