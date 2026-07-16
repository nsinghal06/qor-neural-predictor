module va52e3b_v9a2a06 (
 input [7:0] i1,
 input [15:0] i0,
 output [23:0] o
);
 assign o = {i1, i0};
 
endmodule