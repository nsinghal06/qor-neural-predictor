module v053dc2_vb8adf8 #(
 parameter INI = 0
) (
 input clk,
 input d,
 output q
);
 reg q = INI;
 
 always @(posedge clk)
   q <= d;
endmodule