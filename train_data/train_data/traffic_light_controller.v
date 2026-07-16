//387
module traffic_light_controller(
  input clk,
  input reset,
  input manual_override,
  output reg main_road_lane1,
  output reg main_road_lane2,
  output reg secondary_road_lane1,
  output reg secondary_road_lane2
);

  parameter IDLE = 3'b000;
  parameter MAIN_ROAD_GREEN = 3'b001;
  parameter MAIN_ROAD_YELLOW = 3'b010;
  parameter SECONDARY_ROAD_GREEN = 3'b011;
  parameter SECONDARY_ROAD_YELLOW = 3'b100;

  reg [2:0] state;
  reg [5:0] timer;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      state <= IDLE;
      timer <= 0;
      main_road_lane1 <= 0;
      main_road_lane2 <= 0;
      secondary_road_lane1 <= 0;
      secondary_road_lane2 <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (manual_override) begin
            main_road_lane1 <= 0;
            main_road_lane2 <= 0;
            secondary_road_lane1 <= 0;
            secondary_road_lane2 <= 0;
          end else begin
            main_road_lane1 <= 0;
            main_road_lane2 <= 0;
            secondary_road_lane1 <= 0;
            secondary_road_lane2 <= 0;
            state <= MAIN_ROAD_GREEN;
            timer <= 20'd20;
          end
        end
        MAIN_ROAD_GREEN: begin
          main_road_lane1 <= 1;
          main_road_lane2 <= 1;
          if (timer == 0) begin
            state <= MAIN_ROAD_YELLOW;
            timer <= 20'd5;
          end else begin
            timer <= timer - 1;
          end
        end
        MAIN_ROAD_YELLOW: begin
          main_road_lane1 <= 0;
          main_road_lane2 <= 0;
          if (timer == 0) begin
            state <= SECONDARY_ROAD_GREEN;
            timer <= 20'd20;
          end else begin
            timer <= timer - 1;
          end
        end
        SECONDARY_ROAD_GREEN: begin
          secondary_road_lane1 <= 1;
          secondary_road_lane2 <= 1;
          if (timer == 0) begin
            state <= SECONDARY_ROAD_YELLOW;
            timer <= 20'd5;
          end else begin
            timer <= timer - 1;
          end
        end
        SECONDARY_ROAD_YELLOW: begin
          secondary_road_lane1 <= 0;
          secondary_road_lane2 <= 0;
          if (timer == 0) begin
            state <= MAIN_ROAD_GREEN;
            timer <= 20'd20;
          end else begin
            timer <= timer - 1;
          end
        end
      endcase
    end
  end

endmodule