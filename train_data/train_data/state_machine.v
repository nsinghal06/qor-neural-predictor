//1378
module state_machine (
  input clk,
  input reset,
  input in,
  input [9:0] state,
  output reg [9:0] next_state,
  output reg out1,
  output reg out2
);

  // Define the 10 states using one-hot encoding
  parameter S0 = 10'b0000000001;
  parameter S1 = 10'b0000000010;
  parameter S2 = 10'b0000000100;
  parameter S3 = 10'b0000001000;
  parameter S4 = 10'b0000010000;
  parameter S5 = 10'b0000100000;
  parameter S6 = 10'b0001000000;
  parameter S7 = 10'b0010000000;
  parameter S8 = 10'b0100000000;
  parameter S9 = 10'b1000000000;

  // Define the state transition logic using if-else statements
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      next_state <= S0;
      out1 <= 0;
      out2 <= 0;
    end else begin
      case (state)
        S0: begin
          if (in) begin
            next_state = S1;
            out1 = 1;
          end else begin
            next_state = S2;
            out1 = 0;
          end
          out2 = 0;
        end
        S1: begin
          next_state = S3;
          out1 = 0;
          out2 = 0;
        end
        S2: begin
          next_state = S4;
          out1 = 0;
          out2 = 0;
        end
        S3: begin
          if (in) begin
            next_state = S5;
            out1 = 1;
          end else begin
            next_state = S6;
            out1 = 0;
          end
          out2 = 0;
        end
        S4: begin
          if (in) begin
            next_state = S7;
            out1 = 1;
          end else begin
            next_state = S8;
            out1 = 0;
          end
          out2 = 0;
        end
        S5: begin
          if (in) begin
            next_state = S9;
            out1 = 1;
          end else begin
            next_state = S6;
            out1 = 0;
          end
          out2 = 1;
        end
        S6: begin
          if (in) begin
            next_state = S7;
            out1 = 1;
          end else begin
            next_state = S8;
            out1 = 0;
          end
          out2 = 0;
        end
        S7: begin
          next_state = S9;
          out1 = 0;
          out2 = 1;
        end
        S8: begin
          next_state = S9;
          out1 = 0;
          out2 = 0;
        end
        S9: begin
          next_state = S0;
          out1 = 0;
          out2 = 0;
        end
      endcase
    end
  end

endmodule