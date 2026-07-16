//954
module bitwise_xor
#(parameter WIDTH = 8)
(
  input         clk,
  input         reset,
  input  [WIDTH-1:0] a,
  input  [WIDTH-1:0] b,
  output [WIDTH-1:0] xor_out,
  output        valid
);

  reg [WIDTH-1:0] xor_reg;
  reg            valid_reg;

  always @(posedge clk) begin
    if (reset) begin
      xor_reg  <= 0;
      valid_reg <= 0;
    end else begin
      xor_reg  <= a ^ b;
      valid_reg <= 1;
    end
  end

  assign xor_out = xor_reg;
  assign valid   = valid_reg;

endmodule