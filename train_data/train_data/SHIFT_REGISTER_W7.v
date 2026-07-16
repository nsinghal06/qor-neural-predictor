//152
module SHIFT_REGISTER_W7 (
  input CLK,
  input EN,
  input [6:0] PI,
  output SO
);

  reg [6:0] shift_reg;

  always @(posedge CLK) begin
    if (EN) begin
      shift_reg <= {shift_reg[5:0], PI[6]};
    end
  end

  assign SO = shift_reg[0];

endmodule