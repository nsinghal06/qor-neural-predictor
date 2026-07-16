module v306ca3_v9a2a06 (
 input [15:0] i,
 output [7:0] o1,
 output [7:0] o0
);
 assign o1 = i[15:8];
 assign o0 = i[7:0];
endmodule