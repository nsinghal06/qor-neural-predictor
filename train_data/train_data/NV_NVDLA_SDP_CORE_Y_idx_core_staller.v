module NV_NVDLA_SDP_CORE_Y_idx_core_staller (
  nvdla_core_clk, nvdla_core_rstn, core_wen, chn_lut_in_rsci_wen_comp, core_wten,
      chn_lut_out_rsci_wen_comp
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  output core_wen;
  input chn_lut_in_rsci_wen_comp;
  output core_wten;
  reg core_wten;
  input chn_lut_out_rsci_wen_comp;



  // Interconnect Declarations for Component Instantiations 
  assign core_wen = chn_lut_in_rsci_wen_comp & chn_lut_out_rsci_wen_comp;
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      core_wten <= 1'b0;
    end
    else begin
      core_wten <= ~ core_wen;
    end
  end
endmodule