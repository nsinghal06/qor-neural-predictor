module barrel_shift_4bit (
    input [3:0] in,
    input [1:0] shift,
    output [3:0] out
);

    assign out = (shift == 2'b00) ? in :
                 (shift == 2'b01) ? {in[0], in[3:1]} :
                 (shift == 2'b10) ? {in[1:0], in[3:2]} :
                                    {in[2:0], in[3]};

endmodule