//527
module ram_register #(
    parameter width = 1      // data width
)(
    input [width-1:0] d,
    input clk,
    input aclr,
    input devclrn,
    input devpor,
    input stall,
    input ena,
    output [width-1:0] q,
    output aclrout
);

parameter preset = 1'b0;  // clear acts as preset

reg [width-1:0] q_reg;
reg aclrout_reg;

always @(posedge clk) begin
    // Reset conditions
    if (~devclrn || ~devpor || aclr) begin
        q_reg <= {width{preset}};
        aclrout_reg <= 1'b1;
    // Normal operation
    end else if (ena && !stall) begin
        q_reg <= d;
        aclrout_reg <= aclr;
    end
end

assign q = q_reg;
assign aclrout = aclrout_reg;

endmodule