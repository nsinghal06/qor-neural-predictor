//720
module fsm_6bit_sequence_detection (
  input clk,
  input reset,
  input data,
  input ack,
  output reg match
);
  parameter IDLE = 2'b00, S1 = 2'b01, S2 = 2'b10, DONE = 2'b11;
  reg [1:0] state, next_state;
  reg [5:0] shift_reg;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      shift_reg <= 6'b0;
    end
    else begin
      state <= next_state;
      shift_reg <= {shift_reg[4:0], data};
    end
  end
  
  always @(*) begin
    case(state)
      IDLE: begin
        if (shift_reg == 6'b101010)
          next_state = S1;
        else
          next_state = IDLE;
      end
      
      S1: begin
        if (shift_reg == 6'b101010)
          next_state = S1;
        else
          next_state = S2;
      end
      
      S2: begin
        if (shift_reg == 6'b101010)
          next_state = S1;
        else
          next_state = IDLE;
      end
      
      DONE: begin
        if (ack)
          next_state = IDLE;
        else
          next_state = DONE;
      end
    endcase
  end
  
  // Fix: Use a blocking assignment to drive the match signal
  always @(posedge clk) begin
    if (reset)
      match <= 1'b0;
    else
      match <= (state == DONE);
  end
  
endmodule