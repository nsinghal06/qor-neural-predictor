module vafb28f_v9a2a06 (
 input [3:0] i1,
 input [3:0] i0,
 output [7:0] o
);
 assign o = {i1, i0};
 
endmodule