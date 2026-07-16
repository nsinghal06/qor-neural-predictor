//819
module ulight_fifo_write_data_fifo_tx (
  // inputs:
  input [1:0] address,
  input chipselect,
  input clk,
  input reset_n,
  input write_n,
  input [31:0] writedata,

  // outputs:
  output [8:0] out_port,
  output [31:0] readdata
);

  reg [8:0] data_out;
  wire [8:0] read_mux_out;

  assign read_mux_out = {9{(address == 0)}} & data_out;
  assign out_port = data_out;
  assign readdata = {32'b0, read_mux_out};

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      data_out <= 0;
    end else if (chipselect && ~write_n && (address == 0)) begin
      data_out <= writedata[8:0];
    end
  end

endmodule