//689
module OneHotStateMachine #(
  parameter n = 4
) (
  input clk,
  input rst,
  output [n-1:0] out
);


reg [n-1:0] state; // register to hold the current state

always @(posedge clk) begin
  if (rst) begin
    state <= 0; // reset the state to 0
  end else begin
    // set the next state based on the current state
    case (state)
      0: state <= 1;
      1: state <= 2;
      2: state <= 3;
      3: state <= 0;
      default: state <= 0;
    endcase
  end
end

// assign the output signals based on the current state
assign out = {state == 0, state == 1, state == 2, state == 3};

endmodule