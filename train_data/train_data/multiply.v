module multiply (
    clk,
    ce,
    a,
    b,
    p
);

parameter ID = 32'd1;
parameter NUM_STAGE = 32'd1;
parameter din0_WIDTH = 32'd1;
parameter din1_WIDTH = 32'd1;
parameter dout_WIDTH = 32'd1;

input clk;
input ce;
input signed [din0_WIDTH - 1:0] a;
input signed [din1_WIDTH - 1:0] b;
output signed [2*dout_WIDTH-1:0] p;

wire signed [din0_WIDTH - 1:0] a_temp;
wire signed [din1_WIDTH - 1:0] b_temp;
wire signed [2*dout_WIDTH-1:0] p_temp;

assign a_temp = a;
assign b_temp = b;
assign p_temp = a_temp * b_temp;

assign p = p_temp;

endmodule