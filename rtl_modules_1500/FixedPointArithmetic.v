//163
module FixedPointArithmetic (
  input signed [INT_BITS+FRACT_BITS-1:0] A,
  input signed [INT_BITS+FRACT_BITS-1:0] B,
  input [1:0] CTRL,
  input CLK,
  output signed [INT_BITS+FRACT_BITS-1:0] OUT
);

parameter INT_BITS = 4; // number of integer bits
parameter FRACT_BITS = 4; // number of fractional bits

reg signed [INT_BITS+FRACT_BITS-1:0] result; // internal signal for storing the result

always @(posedge CLK) begin
  case (CTRL)
    2'b00: result <= A + B; // addition
    2'b01: result <= A - B; // subtraction
    2'b10: result <= (A * B) >>> FRACT_BITS; // multiplication
    2'b11: result <= (A / B); // division
  endcase
end

assign OUT = result;

endmodule