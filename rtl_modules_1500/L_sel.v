//21
module L_sel (
    input [1:0] rot,
    output [15:0] block
);

assign block = (rot == 2'b00) ? 16'b0100010011000000 :
               (rot == 2'b01) ? 16'b0000111010000000 :
               (rot == 2'b10) ? 16'b1100010001000000 :
               (rot == 2'b11) ? 16'b0010111000000000 : 16'b0100010011000000;

endmodule