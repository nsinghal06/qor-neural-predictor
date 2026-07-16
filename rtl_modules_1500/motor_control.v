//1065
module motor_control (
  input clk,
  input rst,
  input [1:0] dir,
  input [7:0] duty_cycle,
  input [15:0] frequency,
  input [15:0] steps,
  output pwm_out,
  output h_bridge_out,
  output step_out
);

// parameter declaration
parameter PWM_WIDTH = 8; // width of the PWM signal
parameter H_BRIDGE_WIDTH = 1; // width of the H-bridge signal
parameter STEP_WIDTH = 1; // width of the step signal

// sub-block instantiation
PWM pwm_inst (
  .clk(clk),
  .rst(rst),
  .duty_cycle(duty_cycle),
  .frequency(frequency),
  .pwm_out(pwm_out)
);

H_bridge h_bridge_inst (
  .clk(clk),
  .rst(rst),
  .dir(dir),
  .pwm_in(pwm_out),
  .h_bridge_out(h_bridge_out)
);

Stepper_motor_controller stepper_inst (
  .clk(clk),
  .rst(rst),
  .dir(dir),
  .steps(steps),
  .step_out(step_out)
);

endmodule

module PWM (
  input clk,
  input rst,
  input [7:0] duty_cycle,
  input [15:0] frequency,
  output reg pwm_out
);

parameter PWM_WIDTH = 8; // width of the PWM signal

reg [15:0] counter;
reg [PWM_WIDTH-1:0] threshold;

always @(posedge clk) begin
  if (rst) begin
    counter <= 0;
    threshold <= 0;
    pwm_out <= 0;
  end else begin
    counter <= counter + 1;
    if (counter == frequency) begin
      counter <= 0;
      threshold <= (duty_cycle * PWM_WIDTH) / 100;
    end
    if (counter < threshold) begin
      pwm_out <= 1;
    end else begin
      pwm_out <= 0;
    end
  end
end

endmodule

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