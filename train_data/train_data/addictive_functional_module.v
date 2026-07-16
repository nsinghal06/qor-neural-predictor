module addictive_functional_module(
    input [2:0] shift_reg_out,
    input [2:0] comb_out,
    output reg [2:0] out
);

always @* out = (shift_reg_out + comb_out) % 7;

endmodule