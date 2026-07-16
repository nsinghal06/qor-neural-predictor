//114
module register_with_lut
  (input CLK,
   input CE,
   input CLR,
   input [3:0] I,
   input LUT_I0,
   input LUT_I1,
   output [3:0] O,
   output LUT_O);

  wire LUT_out;
  assign LUT_out = {LUT_I0, LUT_I1};

  reg [3:0] reg_out;
  always @(posedge CLK) begin
    if (CLR) begin
      reg_out <= 4'h0;
    end else if (CE) begin
      reg_out <= I;
    end
  end

  assign O = reg_out;
  assign LUT_O = LUT_out;

endmodule