//76
module jtag_uart_interface (
  input clk,
  input fifo_clear,
  input [7:0] fifo_wdata,
  input fifo_wr,
  input rd_wfifo,
  output fifo_FF,
  output [7:0] r_dat,
  output wfifo_empty,
  output [5:0] wfifo_used
);

  reg [7:0] fifo_rdata;
  reg [31:0] fifo_level;

  always @(posedge clk) begin
    if (fifo_clear)
      begin
        fifo_rdata <= 8'h00;
        fifo_level <= 32'h00000000;
      end
    else if (fifo_wr)
      begin
        fifo_rdata <= fifo_wdata;
        fifo_level <= fifo_level + 1;
      end
    else if (rd_wfifo)
      begin
        fifo_level <= fifo_level - 1;
        if (fifo_level == 32'h00000000)
          fifo_rdata <= 8'h00;
      end
  end

  assign r_dat = fifo_rdata;
  assign fifo_FF = ~wfifo_empty;
  assign wfifo_empty = (fifo_level == 0);
  assign wfifo_used = fifo_level;

endmodule