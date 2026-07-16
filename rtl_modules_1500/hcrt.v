//1078
module hcrt
  (
   input            m_sr01_b3,  
   input            h_reset_n,
   input            t_crt_clk,
   input            cclk_en,        input            dclk_en,        input            h_hclk,
   input 	    color_mode,     input 	    h_io_16,        input 	    h_io_wr,        input [15:0]     h_addr,         input [5:0] 	    c_crtc_index,   input [7:0] 	    c_ext_index,    input            misc_b6,        input            a_ar10_b0,      input            cr11_b7,        input            line_cmp,       
   input            a_ar10_b5,      input            cr17_b2,        input            byte_pan_en,
   input            cr08_b5,        input            cr08_b6,        input            cr17_b7,        input            sr_00_06_wr,
   input            sr07_wr,
   input [15:8]     h_io_dbus,

   output reg [7:0] reg_ht,         output reg [7:0] reg_hde,        output reg [7:0] reg_hbs,        output reg [7:0] reg_hbe,        output reg [7:0] reg_hss,        output reg [7:0] reg_hse,        output           cr03_b7,
   output           c_t_hsync,      output           c_ahde,
   output           c_ahde_1,
   output           c_ahde_1_u,
   output           hblank,
   output           hde,            output           lclk_or_by_2,   output reg       int_crt_line_end
   );

  reg [8:0] 	   hcrt_cntr_op;

  reg 		   pulse0, pulse1;
  reg              hblank_e_eq;     reg              skew_hde;
  reg [1:0]        byte_pan_ff;
  reg              ht_eq_byte_pan;
  reg              lclk_src_ff;
  reg              lclk_src_ff_by_2_ff;
  reg              hrtc_ff;
  reg              hrtc_delayed;
  reg              hrtc_final_d0_ff;
  reg              hde_ff;
  reg [1:0]        ahde_ff_p_cc;
  reg              ahde_ff_p_dc0;
  reg              ahde_ff;
  reg              crt_line_end_ff;
  reg              hblank_ff;
  reg              wr_sr07_06_ff;
  reg              syn_hsync_ff;
  reg              sr_00_06_wr_ff;
  reg              sr07_wr_ff;
  reg [1:0] 	   sll_0, sll_1; reg [4:0] 	   hrtc_d0_ff_d_cc;
  
  wire [2:0]       hrtc_d0_ff;
  wire             hrtc_d0_ff_2;

  wire             raw_hsync;
  wire             hcrt_cntr_rst_n; wire             sr07_wr_syn_cclk;     wire             sr_00_06_wr_syn_cclk;     wire             wr_sr07_06_n;    wire             ht_eq_raw;       wire             ht_eq;				   
  wire             hdisp_eq_raw;    wire             hdisp_eq;				   
  wire             hblank_s_eq;     wire             hsync_s_eq;      wire             hsync_e_eq;      wire [8:0]       htotal;          wire [8:0]       hdisp;           wire [8:0]       hblank_s;        wire [7:0]       hblank_e;        wire [8:0]       hsync_s;         wire [4:0]       hsync_e ;        reg [4:0] 	   ht_eq_d;         wire [1:0]       baseline_skew;   wire             skew_en;         wire [1:0]       byte_pan_ctl;
  wire             crt_line_end;
  wire             hdisp_skew;
  wire             lclk_pulse;
  wire             lower_equal;
  wire             ht_pulse_n;      reg [6:0] 	   hdisp_eq_d;
  wire             hblank_eq_s_or_e;
  wire             hsync_eq_s_or_e;
  wire             pix_pan = a_ar10_b5;
  wire             text_n  = a_ar10_b0;
  reg [2:0] 	   hrtc_d_cc;
  wire [1:0]       hrtc_skew_ctl;
  wire             hrtc_delayed_op;
  reg [1:0] 	   hrtc_delayed_op_d_cc;
  wire             hrtc_final;
  wire             hsync_en = cr17_b7 ;    wire             ht_zero_n;  wire             int_hsync;
  wire             int_hsync2;
  wire             tmp_lclk_or_by_2;
  wire             hsync_pol = misc_b6;
  
  always @(posedge h_hclk or negedge h_reset_n)
    if (~h_reset_n) begin
      reg_ht  <= 8'h0;
      reg_hde <= 8'h0;
      reg_hbs <= 8'h0;
      reg_hbe <= 8'h0;
      reg_hss <= 8'h0;
      reg_hse <= 8'h0;
    end else if (h_io_wr) begin
      case (h_addr)

	16'h03b4: begin
	  if (!color_mode)
	    if (h_io_16) begin
	      case (c_crtc_index[5:0])
		6'h0: if (~cr11_b7) reg_ht  <= h_io_dbus;
		6'h1: if (~cr11_b7) reg_hde <= h_io_dbus;
		6'h2: if (~cr11_b7) reg_hbs <= h_io_dbus;
		6'h3: if (~cr11_b7) reg_hbe <= h_io_dbus;
		6'h4: if (~cr11_b7) reg_hss <= h_io_dbus;
		6'h5: if (~cr11_b7) reg_hse <= h_io_dbus;
	      endcase end
	end

	16'h03b5: begin
	  if (!color_mode) begin
	    case (c_crtc_index[5:0])
	      6'h0: if (~cr11_b7) reg_ht  <= h_io_dbus;
	      6'h1: if (~cr11_b7) reg_hde <= h_io_dbus;
	      6'h2: if (~cr11_b7) reg_hbs <= h_io_dbus;
	      6'h3: if (~cr11_b7) reg_hbe <= h_io_dbus;
	      6'h4: if (~cr11_b7) reg_hss <= h_io_dbus;
	      6'h5: if (~cr11_b7) reg_hse <= h_io_dbus;
	    endcase end
	end

	16'h03d4: begin
	  if (color_mode)
	    if (h_io_16) begin
	      case (c_crtc_index[5:0])
		6'h0: if (~cr11_b7) reg_ht  <= h_io_dbus;
		6'h1: if (~cr11_b7) reg_hde <= h_io_dbus;
		6'h2: if (~cr11_b7) reg_hbs <= h_io_dbus;
		6'h3: if (~cr11_b7) reg_hbe <= h_io_dbus;
		6'h4: if (~cr11_b7) reg_hss <= h_io_dbus;
		6'h5: if (~cr11_b7) reg_hse <= h_io_dbus;
	      endcase end
	end

	16'h03d5: begin
	  if (color_mode) begin
	    case (c_crtc_index[5:0])
	      6'h0: if (~cr11_b7) reg_ht  <= h_io_dbus;
	      6'h1: if (~cr11_b7) reg_hde <= h_io_dbus;
	      6'h2: if (~cr11_b7) reg_hbs <= h_io_dbus;
	      6'h3: if (~cr11_b7) reg_hbe <= h_io_dbus;
	      6'h4: if (~cr11_b7) reg_hss <= h_io_dbus;
	      6'h5: if (~cr11_b7) reg_hse <= h_io_dbus;
	    endcase end
	end
      endcase end
	
  assign           htotal   = { 1'b0, reg_ht };
  assign           hdisp    = { 1'b0, reg_hde };
  assign           hblank_s = { 1'b0, reg_hbs };
  assign           hblank_e = { 2'b0, reg_hse[7], reg_hbe[4:0] };
  assign           hsync_s  = { 1'b0, reg_hss };
  assign           hsync_e  = reg_hse[4:0];

  always @(posedge h_hclk) begin
    if( (~h_reset_n) | (sr07_wr_ff) )
      sr_00_06_wr_ff <= 1'b0;
    else if(sr_00_06_wr == 1'b1)
      sr_00_06_wr_ff <= 1'b1;
  end

  always @(posedge h_hclk) begin
    if( (~h_reset_n) | (sr_00_06_wr_ff) )
      sr07_wr_ff <= 1'b0;
    else if(sr07_wr == 1'b1)
      sr07_wr_ff <= 1'b1;
  end

  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) begin
      sll_0 <= 2'b0;
      sll_1 <= 2'b0;
    end else if (dclk_en) begin
      sll_0 <= {sll_0[0], sr_00_06_wr_ff};
      sll_1 <= {sll_1[0], sr07_wr_ff};
    end

  assign sr_00_06_wr_syn_cclk = sll_0[1];
  assign sr07_wr_syn_cclk     = sll_1[1];
   
  always @(posedge t_crt_clk or negedge h_reset_n ) begin
    if (~h_reset_n)              wr_sr07_06_ff <= 1'b0;
    else if (cclk_en) begin
      if (sr_00_06_wr_syn_cclk)  wr_sr07_06_ff <= 1'b0;
      else if (sr07_wr_syn_cclk) wr_sr07_06_ff <= 1'b1;
    end
  end
      
  assign wr_sr07_06_n = (~wr_sr07_06_ff);

  assign hcrt_cntr_rst_n = (wr_sr07_06_n) & ht_pulse_n;

  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)         hcrt_cntr_op <= 9'b0;
    else if (cclk_en)
      if (~hcrt_cntr_rst_n) hcrt_cntr_op <= 9'b0;
      else                  hcrt_cntr_op <= hcrt_cntr_op + 1'b1;

  assign ht_zero_n       = ~(9'b0 == htotal);
  assign ht_eq_raw       = (hcrt_cntr_op == htotal);
  assign hdisp_eq_raw    = (hcrt_cntr_op == hdisp);
  assign hblank_s_eq     = (hcrt_cntr_op == hblank_s);
  assign hsync_s_eq      = (hcrt_cntr_op == hsync_s);
  assign hsync_e_eq      = (hcrt_cntr_op[4:0] == hsync_e);
  
  assign lower_equal  = (hcrt_cntr_op[5:0] == hblank_e[5:0]);
  
  always @(lower_equal)
      hblank_e_eq = lower_equal; assign ht_eq = ht_eq_d[0] ? ~hdisp_eq_d[2] : (ht_eq_raw & ht_zero_n);

  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)   ht_eq_d <= 5'b0;
    else if (cclk_en) ht_eq_d <= {ht_eq_d[3:0], ht_eq};
  
  assign ht_pulse_n = ~(ht_eq_d[3] & (~ht_eq_d[4])); 
  
  assign hdisp_eq   = hdisp_eq_d[0] ? ~hdisp_eq_raw : ht_eq_d[3];
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)   hdisp_eq_d <= 7'b0;
    else if (cclk_en) hdisp_eq_d <= {hdisp_eq_d[5:0], hdisp_eq};

  assign baseline_skew[1:0] = reg_hbe[6:5];
  always @(baseline_skew or hdisp_eq_d) begin
    case(baseline_skew)
      2'b00:
      	skew_hde = hdisp_eq_d[0];
      2'b01:
      	skew_hde = hdisp_eq_d[1];
      2'b10:
      	skew_hde = hdisp_eq_d[2];
      2'b11:
      	skew_hde = hdisp_eq_d[3];
    endcase
  end
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)
      hde_ff <= 1'b0;
    else if (cclk_en)
      hde_ff <= skew_hde;
  
  assign hde = hde_ff;
  
  assign skew_en  = baseline_skew[0] | baseline_skew[1];
  
  assign hdisp_skew = skew_en ? hdisp_eq_d[3] : hdisp_eq_d[1];
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n) begin
      byte_pan_ff[0] <= 1'b0;
      byte_pan_ff[1] <= 1'b0;
    end else if (byte_pan_en) begin
      byte_pan_ff[0] <= cr08_b5;
      byte_pan_ff[1] <= cr08_b6;
    end
  
  assign byte_pan_ctl[0] = ( byte_pan_ff[0] & (~line_cmp) ) |
      	       	     	   ( byte_pan_ff[0] & (~pix_pan) );
  assign byte_pan_ctl[1] = ( byte_pan_ff[1] & (~line_cmp) ) |
      	       	     	     ( byte_pan_ff[1] & (~pix_pan) );
  
  always @(byte_pan_ctl or ht_eq_d)
    begin
      case(byte_pan_ctl)
        2'b00:
      	  ht_eq_byte_pan = ht_eq_d[3];
        2'b01:
      	  ht_eq_byte_pan = ht_eq_d[2];
        2'b10:
      	  ht_eq_byte_pan = ht_eq_d[1];
        2'b11:
      	  ht_eq_byte_pan = ht_eq_d[0];
      endcase
    end
   
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n) begin
      ahde_ff_p_cc[1] <= 1'b0;
      ahde_ff_p_cc[0] <= 1'b0;	 
      ahde_ff_p_dc0   <= 1'b0;
    end else if (cclk_en) begin
      ahde_ff_p_cc[1] <= ( hdisp_skew | ht_eq_byte_pan );
      ahde_ff_p_cc[0] <= ahde_ff_p_cc[1];
      ahde_ff_p_dc0   <= ahde_ff_p_cc[0];
    end
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)
      ahde_ff <= 1'b0;
    else if (dclk_en)
      ahde_ff <= ahde_ff_p_dc0;
	 
  assign c_ahde      = ahde_ff;
  assign c_ahde_1    = ahde_ff_p_cc[0];
  assign c_ahde_1_u  = ahde_ff_p_cc[1];
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)
      crt_line_end_ff <= 1'b0;
    else if (cclk_en)
      crt_line_end_ff <= (c_ahde | hde) ;
  
  assign crt_line_end = (crt_line_end_ff) &(~(c_ahde | hde));
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)   int_crt_line_end <= 1'b0;
    else if (cclk_en) int_crt_line_end <= crt_line_end;
  
  assign lclk_pulse   = (~hdisp_eq_d[2]) & hdisp_eq_d[6];
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n) begin
      lclk_src_ff <= 1'b0;
      lclk_src_ff_by_2_ff <= 1'b0;
    end else if (cclk_en) begin
      lclk_src_ff         <= lclk_pulse;
      if (~lclk_src_ff & lclk_pulse) 
	lclk_src_ff_by_2_ff <= ~lclk_src_ff_by_2_ff;
    end

  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n) begin
      pulse0 <= 1'b0;
      pulse1 <= 1'b0;
    end else begin
      pulse0 <= cclk_en & ~lclk_src_ff & lclk_pulse;
      pulse1 <= cclk_en & ~lclk_src_ff & lclk_pulse & 
		~lclk_src_ff_by_2_ff & lclk_src_ff_by_2_ff;
    end 

  assign lclk_or_by_2 = cr17_b2 ? pulse1 : pulse0;
    
  assign hblank_eq_s_or_e = hblank_ff ? (~hblank_e_eq) : hblank_s_eq;

  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)
      hblank_ff <= 1'b0;
    else if (cclk_en)
      hblank_ff <= hblank_eq_s_or_e;
  
  assign hblank = hblank_ff;
  
  assign hsync_eq_s_or_e = hrtc_ff ? (~hsync_e_eq) : hsync_s_eq;	 
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)
      hrtc_ff <= 1'b0;
    else if (cclk_en)
      hrtc_ff <= hsync_eq_s_or_e;
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)   hrtc_d_cc <= 3'b0;
    else if (cclk_en) hrtc_d_cc <= {hrtc_d_cc[1:0], hrtc_ff};

  assign hrtc_skew_ctl[1:0] = reg_hse[6:5];
  always @(hrtc_skew_ctl or hrtc_d_cc or hrtc_ff)
    begin
      case(hrtc_skew_ctl)
        2'b00:
      	  hrtc_delayed = hrtc_ff;
        2'b01:
      	  hrtc_delayed = hrtc_d_cc[0];
        2'b10:
      	  hrtc_delayed = hrtc_d_cc[1];
        2'b11:
      	  hrtc_delayed = hrtc_d_cc[2];
      endcase
    end
   

  assign  hrtc_delayed_op = hrtc_delayed & hsync_en;
 
  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)   hrtc_delayed_op_d_cc <= 2'b0;
    else if (cclk_en) hrtc_delayed_op_d_cc <= {hrtc_delayed_op_d_cc[0], 
					       hrtc_delayed_op};

  assign  hrtc_final = text_n ? (((hrtc_delayed_op_d_cc[0] | 
				   ~m_sr01_b3)) & hrtc_delayed_op_d_cc[1]) : 
				  (((hrtc_delayed_op | ~m_sr01_b3)) & 
				   hrtc_delayed_op_d_cc[0]); 
      
  assign  hrtc_d0_ff_2 = hrtc_final;

  always @(posedge t_crt_clk or negedge h_reset_n)
    if (!h_reset_n)   hrtc_d0_ff_d_cc <= 5'b0;
    else if (dclk_en) hrtc_d0_ff_d_cc <= {hrtc_d0_ff_d_cc[3:0], hrtc_d0_ff_2};
  
  assign  raw_hsync   = hrtc_d0_ff_d_cc[4];
  assign  int_hsync   = (hsync_en & raw_hsync) ^ hsync_pol;
  assign  int_hsync2 = int_hsync;
  
  always @(posedge t_crt_clk or negedge h_reset_n)
    if(~h_reset_n)
      syn_hsync_ff <= 1'b0;
    else
      syn_hsync_ff <= int_hsync2;
  
  assign  c_t_hsync = syn_hsync_ff;
  
  assign  cr03_b7 = reg_hbe[7];
  
endmodule