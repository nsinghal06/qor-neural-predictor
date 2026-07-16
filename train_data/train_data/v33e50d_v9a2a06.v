module v33e50d_v9a2a06 (
 input [7:0] i2,
 input [7:0] i1,
 input [7:0] i0,
 output [23:0] o
);
 assign o = {i2, i1, i0};
 
endmodule