module signed_multiplier (
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

wire [2*dout_WIDTH-1:0] mul_result;

multiply multiplier_U (
    .clk( clk ),
    .ce( ce ),
    .a( a ),
    .b( b ),
    .p( mul_result ));

assign p = mul_result;

endmodule