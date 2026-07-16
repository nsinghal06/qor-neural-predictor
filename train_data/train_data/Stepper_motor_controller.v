module Stepper_motor_controller (
  input clk,
  input rst,
  input [1:0] dir,
  input [15:0] steps,
  output reg step_out
);

parameter STEP_WIDTH = 1; // width of the step signal

reg [15:0] counter;

always @(posedge clk) begin
  if (rst) begin
    counter <= 0;
    step_out <= 0;
  end else begin
    if (counter == steps) begin
      counter <= 0;
    end else begin
      counter <= counter + 1;
      if (dir == 0) begin
        step_out <= 1;
      end else begin
        step_out <= 0;
      end
    end
  end
end

endmodule