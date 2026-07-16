//1022
module trace_memory_controller (
  input clk,
  input [36:1] jdo,
  input jrst_n,
  input reset_n,
  input take_action_tracectrl,
  input take_action_tracemem_a,
  input take_action_tracemem_b,
  input take_no_action_tracemem_a,
  input [15:0] trc_ctrl,
  input [35:0] tw,
  output reg tracemem_on,
  output reg [35:0] tracemem_trcdata,
  output reg tracemem_tw,
  output reg trc_enb,
  output reg [6:0] trc_im_addr,
  output reg trc_wrap,
  output reg xbrk_wrap_traceoff
);

  // Declare internal signals and registers
  reg [6:0] trc_im_addr_reg;
  reg trc_wrap_reg;
  reg [16:0] trc_jtag_addr_reg;
  reg [35:0] trc_jtag_data_reg;
  reg trc_enb_reg;
  reg tracemem_on_reg;
  reg [35:0] tracemem_trcdata_reg;
  reg tracemem_tw_reg;
  reg xbrk_wrap_traceoff_reg;
  wire [35:0] trc_im_data;

  // Instantiate on-chip memory
  // nios_tdp_ram ddr3_s4_uniphy_example_sim_ddr3_s4_uniphy_example_sim_e0_if0_p0_qsys_sequencer_cpu_inst_traceram_lpm_dram_bdp_component (
  //   .address_a(trc_im_addr_reg),
  //   .address_b(trc_jtag_addr_reg),
  //   .clock0(clk),
  //   .clock1(clk),
  //   .clocken0(1'b1),
  //   .clocken1(1'b1),
  //   .data_a(trc_im_data),
  //   .data_b(jdo[36:1]),
  //   .q_a(),
  //   .q_b(trc_jtag_data_reg),
  //   .wren_a(trc_enb_reg & tracemem_on_reg & tracemem_tw_reg),
  //   .wren_b(take_action_tracemem_b)
  // );

  // Assign trc_im_data to tw
  assign trc_im_data = tw;

  // Assign tracemem_trcdata to trc_jtag_data or 0
  always @* begin
    tracemem_trcdata = (tracemem_on_reg && !tracemem_tw_reg) ? trc_jtag_data_reg : 36'b0;
  end

  // Assign tracemem_tw to trc_wrap_reg
  always @* begin
    tracemem_tw = trc_wrap_reg;
  end

  // Assign tracemem_on to trc_enb_reg
  always @* begin
    tracemem_on = trc_enb_reg;
  end

  // Assign xbrk_wrap_traceoff to trc_wrap_reg and trc_ctrl[10]
  always @* begin
    xbrk_wrap_traceoff = trc_wrap_reg & trc_ctrl[10];
  end

  // Assign outputs
  always @* begin
    trc_enb = trc_enb_reg;
    trc_im_addr = trc_im_addr_reg;
    trc_wrap = trc_wrap_reg;
  end

  // Process clock and reset signals
  always @(posedge clk or negedge jrst_n) begin
    if (~jrst_n) begin
      trc_im_addr_reg <= 7'b0;
      trc_wrap_reg <= 1'b0;
    end else if (~reset_n) begin
      trc_im_addr_reg <= 7'b0;
      trc_wrap_reg <= 1'b0;
    end else begin
      // Process take_action_tracectrl signal
      if (take_action_tracectrl && (jdo[4] || jdo[3])) begin
        if (jdo[4]) trc_im_addr_reg <= 7'b0;
        if (jdo[3]) trc_wrap_reg <= 1'b0;
      end else begin
        // Process trc_enb and trc_on_chip signals
        if (trc_enb_reg && !trc_ctrl[8] && |trc_im_data[35:32]) begin
          trc_im_addr_reg <= trc_im_addr_reg + 1;
          if (&trc_im_addr_reg) trc_wrap_reg <= 1'b1;
        end
      end
    end
  end

  // Process take_action_tracemem_a signal
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) trc_jtag_addr_reg <= 17'b0;
    else if (take_action_tracemem_a) trc_jtag_addr_reg <= jdo[35:19];
  end

  // Process take_action_tracemem_a, take_no_action_tracemem_a, and take_action_tracemem_b signals
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) trc_jtag_data_reg <= 36'b0;
    else if (take_action_tracemem_a || take_no_action_tracemem_a || take_action_tracemem_b) begin
      if (take_action_tracemem_a) trc_jtag_data_reg <= {trc_jtag_data_reg[35:0], jdo[18:1]};
      else if (take_no_action_tracemem_a) trc_jtag_data_reg <= {trc_jtag_data_reg[35:0], 36'b0};
      else if (take_action_tracemem_b) trc_jtag_data_reg <= {trc_jtag_data_reg[35:0], jdo[36:19]};
    end
  end

  // Process trc_enb signal
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) trc_enb_reg <= 1'b0;
    else trc_enb_reg <= trc_ctrl[0];
  end

  // Process tracemem_on signal
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) tracemem_on_reg <= 1'b0;
    else tracemem_on_reg <= trc_ctrl[1];
  end

  // Process tracemem_tw signal
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) tracemem_tw_reg <= 1'b0;
    else tracemem_tw_reg <= trc_ctrl[2];
  end

endmodule