//1004
module pipelined_decoder (
    input [1:0] in,
    input clk,
    output [15:0] out
);

reg [15:0] stage1_out;
reg [15:0] stage2_out;
reg [15:0] stage3_out;

always @ (posedge clk) begin
    stage1_out <= {16{1'b0}};
    stage1_out[in] <= 1'b1;
end

always @ (posedge clk) begin
    stage2_out <= stage1_out;
end

always @ (posedge clk) begin
    stage3_out <= stage2_out;
end

assign out = stage3_out;

endmodule