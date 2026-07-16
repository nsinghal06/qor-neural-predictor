//1188
module ppu_bg
(
  input  wire        clk_in,             input  wire        rst_in,             input  wire        en_in,              input  wire        ls_clip_in,         input  wire [ 2:0] fv_in,              input  wire [ 4:0] vt_in,              input  wire        v_in,               input  wire [ 2:0] fh_in,              input  wire [ 4:0] ht_in,              input  wire        h_in,               input  wire        s_in,               input  wire [ 9:0] nes_x_in,           input  wire [ 9:0] nes_y_in,           input  wire [ 9:0] nes_y_next_in,      input  wire        pix_pulse_in,       input  wire [ 7:0] vram_d_in,          input  wire        ri_upd_cntrs_in,    input  wire        ri_inc_addr_in,     input  wire        ri_inc_addr_amt_in, output reg  [13:0] vram_a_out,         output wire [ 3:0] palette_idx_out     );

reg [ 2:0] q_fvc,           d_fvc;            reg [ 4:0] q_vtc,           d_vtc;            reg        q_vc,            d_vc;             reg [ 4:0] q_htc,           d_htc;            reg        q_hc,            d_hc;             reg [ 7:0] q_par,           d_par;            reg [ 1:0] q_ar,            d_ar;             reg [ 7:0] q_pd0,           d_pd0;            reg [ 7:0] q_pd1,           d_pd1;            reg [ 8:0] q_bg_bit3_shift, d_bg_bit3_shift;  reg [ 8:0] q_bg_bit2_shift, d_bg_bit2_shift;  reg [15:0] q_bg_bit1_shift, d_bg_bit1_shift;  reg [15:0] q_bg_bit0_shift, d_bg_bit0_shift;  always @(posedge clk_in)
  begin
    if (rst_in)
      begin
        q_fvc           <=  2'h0;
        q_vtc           <=  5'h00;
        q_vc            <=  1'h0;
        q_htc           <=  5'h00;
        q_hc            <=  1'h0;
        q_par           <=  8'h00;
        q_ar            <=  2'h0;
        q_pd0           <=  8'h00;
        q_pd1           <=  8'h00;
        q_bg_bit3_shift <=  9'h000;
        q_bg_bit2_shift <=  9'h000;
        q_bg_bit1_shift <= 16'h0000;
        q_bg_bit0_shift <= 16'h0000;
      end
    else
      begin
        q_fvc           <= d_fvc;
        q_vtc           <= d_vtc;
        q_vc            <= d_vc;
        q_htc           <= d_htc;
        q_hc            <= d_hc;
        q_par           <= d_par;
        q_ar            <= d_ar;
        q_pd0           <= d_pd0;
        q_pd1           <= d_pd1;
        q_bg_bit3_shift <= d_bg_bit3_shift;
        q_bg_bit2_shift <= d_bg_bit2_shift;
        q_bg_bit1_shift <= d_bg_bit1_shift;
        q_bg_bit0_shift <= d_bg_bit0_shift;
      end
  end

reg upd_v_cntrs;
reg upd_h_cntrs;
reg inc_v_cntrs;
reg inc_h_cntrs;

always @*
  begin
    d_fvc = q_fvc;
    d_vc  = q_vc;
    d_hc  = q_hc;
    d_vtc = q_vtc;
    d_htc = q_htc;

    if (ri_inc_addr_in)
      begin
        if (ri_inc_addr_amt_in)
          { d_fvc, d_vc, d_hc, d_vtc } = { q_fvc, q_vc, q_hc, q_vtc } + 10'h001;
        else
          { d_fvc, d_vc, d_hc, d_vtc, d_htc } = { q_fvc, q_vc, q_hc, q_vtc, q_htc } + 15'h0001;
      end
    else
      begin
        if (inc_v_cntrs)
          begin
            if ({ q_vtc, q_fvc } == { 5'b1_1101, 3'b111 })
              { d_vc, d_vtc, d_fvc } = { ~q_vc, 8'h00 };
            else
              { d_vc, d_vtc, d_fvc } = { q_vc, q_vtc, q_fvc } + 9'h001;
          end

        if (inc_h_cntrs)
          begin
            { d_hc, d_htc } = { q_hc, q_htc } + 6'h01;
          end

        if (upd_v_cntrs || ri_upd_cntrs_in)
          begin
            d_vc  = v_in;
            d_vtc = vt_in;
            d_fvc = fv_in;
          end

        if (upd_h_cntrs || ri_upd_cntrs_in)
          begin
            d_hc  = h_in;
            d_htc = ht_in;
          end
      end
  end

localparam [2:0] VRAM_A_SEL_RI       = 3'h0,
                 VRAM_A_SEL_NT_READ  = 3'h1,
                 VRAM_A_SEL_AT_READ  = 3'h2,
                 VRAM_A_SEL_PT0_READ = 3'h3,
                 VRAM_A_SEL_PT1_READ = 3'h4;

reg [2:0] vram_a_sel;

always @*
  begin
    case (vram_a_sel)
      VRAM_A_SEL_NT_READ:
        vram_a_out = { 2'b10, q_vc, q_hc, q_vtc, q_htc };
      VRAM_A_SEL_AT_READ:
        vram_a_out = { 2'b10, q_vc, q_hc, 4'b1111, q_vtc[4:2], q_htc[4:2] };
      VRAM_A_SEL_PT0_READ:
        vram_a_out = { 1'b0, s_in, q_par, 1'b0, q_fvc };
      VRAM_A_SEL_PT1_READ:
        vram_a_out = { 1'b0, s_in, q_par, 1'b1, q_fvc };
      default:
        vram_a_out = { q_fvc[1:0], q_vc, q_hc, q_vtc, q_htc };
    endcase
  end

wire clip;

always @*
  begin
    d_par           = q_par;
    d_ar            = q_ar;
    d_pd0           = q_pd0;
    d_pd1           = q_pd1;
    d_bg_bit3_shift = q_bg_bit3_shift;
    d_bg_bit2_shift = q_bg_bit2_shift;
    d_bg_bit1_shift = q_bg_bit1_shift;
    d_bg_bit0_shift = q_bg_bit0_shift;

    upd_v_cntrs = 1'b0;
    inc_v_cntrs = 1'b0;
    upd_h_cntrs = 1'b0;
    inc_h_cntrs = 1'b0;

    vram_a_sel = VRAM_A_SEL_RI;

    if (en_in && ((nes_y_in < 239) || (nes_y_next_in == 0)))
      begin
        if (pix_pulse_in && (nes_x_in == 319))
          begin
            upd_h_cntrs = 1'b1;

            if (nes_y_next_in != nes_y_in)
              begin
                if (nes_y_next_in == 0)
                  upd_v_cntrs = 1'b1;
                else
                  inc_v_cntrs = 1'b1;
              end
          end

        if ((nes_x_in < 256) || ((nes_x_in >= 320 && nes_x_in < 336)))
          begin
            if (pix_pulse_in)
              begin
                d_bg_bit3_shift = { q_bg_bit3_shift[8], q_bg_bit3_shift[8:1] };
                d_bg_bit2_shift = { q_bg_bit2_shift[8], q_bg_bit2_shift[8:1] };
                d_bg_bit1_shift = { 1'b0, q_bg_bit1_shift[15:1] };
                d_bg_bit0_shift = { 1'b0, q_bg_bit0_shift[15:1] };
              end

            if (pix_pulse_in && (nes_x_in[2:0] == 3'h7))
              begin
                inc_h_cntrs         = 1'b1;

                d_bg_bit3_shift[8]  = q_ar[1];
                d_bg_bit2_shift[8]  = q_ar[0];

                d_bg_bit1_shift[15] = q_pd1[0];
                d_bg_bit1_shift[14] = q_pd1[1];
                d_bg_bit1_shift[13] = q_pd1[2];
                d_bg_bit1_shift[12] = q_pd1[3];
                d_bg_bit1_shift[11] = q_pd1[4];
                d_bg_bit1_shift[10] = q_pd1[5];
                d_bg_bit1_shift[ 9] = q_pd1[6];
                d_bg_bit1_shift[ 8] = q_pd1[7];

                d_bg_bit0_shift[15] = q_pd0[0];
                d_bg_bit0_shift[14] = q_pd0[1];
                d_bg_bit0_shift[13] = q_pd0[2];
                d_bg_bit0_shift[12] = q_pd0[3];
                d_bg_bit0_shift[11] = q_pd0[4];
                d_bg_bit0_shift[10] = q_pd0[5];
                d_bg_bit0_shift[ 9] = q_pd0[6];
                d_bg_bit0_shift[ 8] = q_pd0[7];
              end

            case (nes_x_in[2:0])
              3'b000:
                begin
                  vram_a_sel = VRAM_A_SEL_NT_READ;
                  d_par      = vram_d_in;
                end
              3'b001:
                begin
                  vram_a_sel = VRAM_A_SEL_AT_READ;
                  d_ar       = vram_d_in >> { q_vtc[1], q_htc[1], 1'b0 };
                end
              3'b010:
                begin
                  vram_a_sel = VRAM_A_SEL_PT0_READ;
                  d_pd0      = vram_d_in;
                end
              3'b011:
                begin
                  vram_a_sel = VRAM_A_SEL_PT1_READ;
                  d_pd1      = vram_d_in;
                end
            endcase
          end
      end
  end

assign clip            = ls_clip_in && (nes_x_in >= 10'h000) && (nes_x_in < 10'h008);
assign palette_idx_out = (!clip && en_in) ? { q_bg_bit3_shift[fh_in],
                                              q_bg_bit2_shift[fh_in],
                                              q_bg_bit1_shift[fh_in],
                                              q_bg_bit0_shift[fh_in] } : 4'h0;

endmodule