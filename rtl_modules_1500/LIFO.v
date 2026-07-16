//1196
module LIFO (
  input clk,
  input reset,
  input [7:0] push_data,
  input pop,
  output [7:0] top_data,
  output empty
);

parameter depth = 8; // number of elements in the stack

reg [7:0] stack [depth-1:0]; // stack array
reg [3:0] top = 0; // top of the stack
wire full = (top == depth-1); // full signal

assign empty = (top == 0); // empty signal

always @(posedge clk) begin
  if (reset) begin
    top <= 0;
  end
  else begin
    if (pop && !empty) begin
      top <= top - 1;
    end
    else if (!full) begin
      stack[top] <= push_data;
      top <= top + 1;
    end
  end
end

assign top_data = (empty) ? 8'b0 : stack[top]; // ternary operator to assign top_data

endmodule