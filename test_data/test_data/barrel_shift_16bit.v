module barrel_shift_16bit (
    input [15:0] in,
    input [3:0] shift,
    output [15:0] out
);

    assign out = (shift == 4'b0000) ? in :
                 (shift == 4'b0001) ? {in[0], in[15:1]} :
                 (shift == 4'b0010) ? {in[1:0], in[15:2]} :
                 (shift == 4'b0011) ? {in[2:0], in[15:3]} :
                 (shift == 4'b0100) ? {in[3:0], in[15:4]} :
                 (shift == 4'b0101) ? {in[4:0], in[15:5]} :
                 (shift == 4'b0110) ? {in[5:0], in[15:6]} :
                 (shift == 4'b0111) ? {in[6:0], in[15:7]} :
                 (shift == 4'b1000) ? {in[7:0], in[15:8]} :
                 (shift == 4'b1001) ? {in[8:0], in[15:9]} :
                 (shift == 4'b1010) ? {in[9:0], in[15:10]} :
                 (shift == 4'b1011) ? {in[10:0], in[15:11]} :
                 (shift == 4'b1100) ? {in[11:0], in[15:12]} :
                 (shift == 4'b1101) ? {in[12:0], in[15:13]} :
                 (shift == 4'b1110) ? {in[13:0], in[15:14]} :
                                     {in[14:0], in[15]};

endmodule