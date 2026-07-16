//1051
module register_decoder (
  input         h_hclk,
  input         h_reset_n,
  input  [15:0] h_io_addr,
  input         h_iowr,
  input         h_iord,
  input  [15:0] h_io_16,
  input  [7:0]  h_io_8,
  input         crt_index_hit,
  input         ext_index_hit,
  input         crt_reg_en,
  input  [7:0]  crtc_index,
  output        c_ready_n,
  output        crt_mod_rd_en_hb,
  output        crt_mod_rd_en_lb
);

  reg       rd_or_wr_d;
  wire      c_dec_3ba_or_3da;
  wire      fcr_wr;
  wire      fcr_rd;
  wire      ins0_rd;
  wire      ins1_rd;
  wire      crt_io_hit_lb;
  wire      c_cr0c_f13_22_hit;
  wire      index_from_crtc;
  wire      crt_io_hit_hb;
  wire      cr24_rd;
  wire      cr26_rd;
  wire      crt_io_hit_hb_int;
  wire      crt_io_hit_lb_int;
  wire       \rd_or_wr ;

  // crt_index_hit & h_io_8 - 8-bit read to CR index register
  // ext_index_hit & h_io_8 - 8-bit read to ER index register
  // 3CC: misc rd or write
  assign c_dec_3ba_or_3da = (h_io_addr == 16'h03da) | (h_io_addr == 16'h03ba);
  assign fcr_wr = c_dec_3ba_or_3da & h_iowr;
  assign fcr_rd = (h_io_addr == 16'h03ca) & h_iord;
  assign ins0_rd = (h_io_addr == 16'h03c2) & h_iord;
  assign ins1_rd = c_dec_3ba_or_3da & h_iord;

  assign crt_io_hit_lb = (h_io_addr == 16'h3cc & h_iord) |
                         (h_io_addr == 16'h3c2 & h_iowr) |
                         ins0_rd | ins1_rd |
                         fcr_rd | fcr_wr |
                         (ext_index_hit & (h_io_16 | h_io_8)) |
                         (crt_index_hit & (h_io_16 | h_io_8));

  // delay (h_iowr | h_iord) by one h_hclk and then give it out as c_ready_n
  assign \rd_or_wr  = h_iowr | h_iord;

  always @(posedge h_hclk or negedge h_reset_n)
    if (!h_reset_n) rd_or_wr_d <= 1'b0;
    else            rd_or_wr_d <= \rd_or_wr ;

  assign c_ready_n = (~(rd_or_wr_d & (crt_io_hit_hb | crt_io_hit_lb)));

  // Decoding for io hit for any of cr00 to cr0b, cr10 to cr18, misc, ins0,
  // ins1 and fcr .
  assign crt_io_hit_hb_int = crt_io_hit_lb & h_iord;

  // Decoding for io hit for any of cr0c to cr0f or cr13
  assign c_cr0c_f13_22_hit = crt_reg_en & (((crtc_index >= 8'h0c) &
                                             (crtc_index <= 8'h0f)) |
                                            (crtc_index == 8'd19) |
                                            (crtc_index == 8'd34));

  assign index_from_crtc = c_cr0c_f13_22_hit | cr24_rd | cr26_rd;

  assign cr24_rd = (h_io_addr == 16'h3d4) & h_iord;
  assign cr26_rd = (h_io_addr == 16'h3d5) & h_iord;

  assign crt_io_hit_lb_int = index_from_crtc & h_iord;

  assign crt_mod_rd_en_hb = crt_io_hit_hb_int;
  assign crt_mod_rd_en_lb = crt_io_hit_lb_int;
  assign crt_io_hit_hb = crt_io_hit_lb_int | crt_io_hit_hb_int ;//missing initial value

endmodule