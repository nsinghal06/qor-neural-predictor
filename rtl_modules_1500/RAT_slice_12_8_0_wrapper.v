//627
module RAT_slice_12_8_0_wrapper(
  input clk,
  input reset,
  input [17:0] Din,
  output [4:0] Dout
);

  wire [4:0] Dout_internal;
  RAT_slice_12_8_0 RAT_slice_12_8_0_inst(
    .Din(Din),
    .Dout(Dout_internal)
  );

  reg [4:0] Dout_reg = 5'b0;

  always @(posedge clk) begin
    if (reset) begin
      Dout_reg <= 5'b0;
    end else begin
      Dout_reg <= Dout_internal;
    end
  end

  assign Dout[4] = Dout_reg[4];
  assign Dout[3] = Dout_reg[3];
  assign Dout[2] = Dout_reg[2];
  assign Dout[1] = Dout_reg[1];
  assign Dout[0] = Dout_reg[0];

endmodule

module RAT_slice_12_8_0(
  input [17:0] Din,
  output [4:0] Dout
);

  wire [4:0] Dout_internal;
  assign Dout_internal[4] = Din[17];
  assign Dout_internal[3] = Din[16];
  assign Dout_internal[2] = Din[15];
  assign Dout_internal[1] = Din[14];
  assign Dout_internal[0] = Din[13];
  assign Dout = Dout_internal;

endmodule