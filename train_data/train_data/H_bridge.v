module H_bridge (
  input clk,
  input rst,
  input [1:0] dir,
  input pwm_in,
  output reg h_bridge_out
);

parameter H_BRIDGE_WIDTH = 1; // width of the H-bridge signal

always @(posedge clk) begin
  if (rst) begin
    h_bridge_out <= 0;
  end else begin
    if (dir == 0) begin
      h_bridge_out <= pwm_in;
    end else begin
      h_bridge_out <= ~pwm_in;
    end
  end
end

endmodule