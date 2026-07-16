module ph_reg3
  (
   input        h_rst_b,
   input        h_rd,
   input        h_selectData,
   input        h_phi2,

   input [7:0]  p_data,
   input        p_selectData,
   input        p_phi2,
   input        p_rdnw,
   input        one_byte_mode,
   output [7:0] h_data,
   output       h_data_available,
   output       p_empty,
   output       p_full
   );

   wire         rd_empty;    wire         rd_full;     wire         wr_empty;    wire         wr_full;     async_fifo #
     (
      .D_WIDTH(8),
      .A_WIDTH(1),
      .INIT_WADDR(1),
      .INIT_RADDR(0)
      )
   ph_reg3_fifo
     (
      .rst(!h_rst_b),
      .wr_clk(p_phi2),
      .wr_en(p_selectData && !p_rdnw),
      .wr_data(p_data),
      .rd_clk(!h_phi2),
      .rd_en(h_selectData && h_rd),
      .rd_data(h_data),
      .rd_empty(rd_empty),
      .rd_full(rd_full),
      .wr_empty(wr_empty),
      .wr_full(wr_full)
      );

   assign p_empty          = wr_empty;
   assign p_full           = one_byte_mode ? wr_full   : !wr_empty;
   assign h_data_available = one_byte_mode ? !rd_empty : rd_full;

endmodule