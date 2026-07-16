module async_fifo #
  (
   parameter D_WIDTH = 0,    parameter A_WIDTH = 0,    parameter INIT_WADDR = 0, parameter INIT_RADDR = 0  )
   (
    input        rst,      input        wr_clk,   input        wr_en,    input [7:0]  wr_data,  input        rd_clk,   input        rd_en,    output [7:0] rd_data,  output       rd_empty, output       rd_full,  output       wr_empty, output       wr_full   );

   wire [A_WIDTH:0] waddr;     wire [A_WIDTH:0] waddr_g;   reg [A_WIDTH:0]  waddr_g1;  reg [A_WIDTH:0]  waddr_g2;  wire [A_WIDTH:0] raddr;     wire [A_WIDTH:0] raddr_g;   reg [A_WIDTH:0]  raddr_g1;  reg [A_WIDTH:0]  raddr_g2;  reg [D_WIDTH-1:0] data[0:2^A_WIDTH-1];

   bin_gray_counter #
     (
      .N(A_WIDTH+1),
      .INIT(INIT_WADDR)
      )
   waddr_counter
     (
      .clk(wr_clk),
      .rst(rst),
      .inc(wr_en && !wr_full),
      .binary(waddr),
      .gray(waddr_g)
      );

   bin_gray_counter #
     (
      .N(A_WIDTH+1),
      .INIT(INIT_RADDR)
      )
   addr_counter
     (
      .clk(rd_clk),
      .rst(rst),
      .inc(rd_en && !rd_empty),
      .binary(raddr),
      .gray(raddr_g)
      );

   always @(posedge wr_clk) begin
      raddr_g1 <= raddr_g;
      raddr_g2 <= raddr_g1;
   end

   always @(posedge rd_clk) begin
      waddr_g1 <= waddr_g;
      waddr_g2 <= waddr_g1;
   end

   always @(posedge wr_clk) begin
      if (wr_en && !wr_full) begin
         data[waddr[A_WIDTH-1:0]] <= wr_data;
      end
   end

   assign rd_data = data[raddr[A_WIDTH-1:0]];

   assign wr_empty = (waddr_g ^ raddr_g2) == 0;
   assign rd_empty = (raddr_g ^ waddr_g2) == 0;
   assign wr_full  = (waddr_g ^ raddr_g2) == 3 << (A_WIDTH-1);
   assign rd_full  = (raddr_g ^ waddr_g2) == 3 << (A_WIDTH-1);

endmodule