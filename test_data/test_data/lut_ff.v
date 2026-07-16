module lut_ff(
    aclk,
    input_signals,
    lut_output,
    ff_output
);

input aclk;
input [1:0] input_signals;
output lut_output;
output ff_output;

wire const0;
wire const1;
wire pre_rdy;

assign const0 = 1'b0;
assign const1 = 1'b1;
assign pre_rdy = input_signals[0] & input_signals[1];
assign lut_output = pre_rdy;

DFF dff(
    .clk(aclk),
    .reset(const0),
    .D(pre_rdy),
    .Q(ff_output)
);

endmodule