//1325
module GB_IO(
  input CLOCKENABLE,
  input LATCHINPUTVALUE,
  input INPUTCLK,
  input OUTPUTCLK,
  input OUTPUTENABLE,
  input DOUT0,
  input DOUT1,
  output DIN0,
  output DIN1,
  output GLOBALBUFFEROUTPUT,
  inout PACKAGEPIN
);

  reg [1:0] data_in;
  reg [1:0] data_out;

  assign DIN0 = data_in[0];
  assign DIN1 = data_in[1];

  always @(posedge INPUTCLK) begin
    if (LATCHINPUTVALUE) begin
      data_in <= PACKAGEPIN;
    end
  end

  always @(posedge OUTPUTCLK) begin
    if (OUTPUTENABLE) begin
      data_out[0] <= DOUT0;
      data_out[1] <= DOUT1;
    end
  end

  buf (GLOBALBUFFEROUTPUT, data_out[1]);

  assign PACKAGEPIN = DIN0;

endmodule