module NV_NVDLA_SDP_CORE_Y_idx_core_chn_lut_in_rsci (
  nvdla_core_clk, nvdla_core_rstn, chn_lut_in_rsc_z, chn_lut_in_rsc_vz, chn_lut_in_rsc_lz,
      chn_lut_in_rsci_oswt, core_wen, chn_lut_in_rsci_iswt0, chn_lut_in_rsci_bawt,
      chn_lut_in_rsci_wen_comp, chn_lut_in_rsci_ld_core_psct, chn_lut_in_rsci_d_mxwt,
      core_wten
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [127:0] chn_lut_in_rsc_z;
  input chn_lut_in_rsc_vz;
  output chn_lut_in_rsc_lz;
  input chn_lut_in_rsci_oswt;
  input core_wen;
  input chn_lut_in_rsci_iswt0;
  output chn_lut_in_rsci_bawt;
  output chn_lut_in_rsci_wen_comp;
  input chn_lut_in_rsci_ld_core_psct;
  output [127:0] chn_lut_in_rsci_d_mxwt;
  input core_wten;


  // Interconnect Declarations
  wire chn_lut_in_rsci_biwt;
  wire chn_lut_in_rsci_bdwt;
  wire chn_lut_in_rsci_ld_core_sct;
  wire chn_lut_in_rsci_vd;
  wire [127:0] chn_lut_in_rsci_d;


  // Interconnect Declarations for Component Instantiations 
  SDP_Y_IDX_mgc_in_wire_wait_v1 #(.rscid(32'sd1),
  .width(32'sd128)) chn_lut_in_rsci (
      .ld(chn_lut_in_rsci_ld_core_sct),
      .vd(chn_lut_in_rsci_vd),
      .d(chn_lut_in_rsci_d),
      .lz(chn_lut_in_rsc_lz),
      .vz(chn_lut_in_rsc_vz),
      .z(chn_lut_in_rsc_z)
    );
  NV_NVDLA_SDP_CORE_Y_idx_core_chn_lut_in_rsci_chn_lut_in_wait_ctrl NV_NVDLA_SDP_CORE_Y_idx_core_chn_lut_in_rsci_chn_lut_in_wait_ctrl_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_lut_in_rsci_oswt(chn_lut_in_rsci_oswt),
      .core_wen(core_wen),
      .chn_lut_in_rsci_iswt0(chn_lut_in_rsci_iswt0),
      .chn_lut_in_rsci_ld_core_psct(chn_lut_in_rsci_ld_core_psct),
      .core_wten(core_wten),
      .chn_lut_in_rsci_biwt(chn_lut_in_rsci_biwt),
      .chn_lut_in_rsci_bdwt(chn_lut_in_rsci_bdwt),
      .chn_lut_in_rsci_ld_core_sct(chn_lut_in_rsci_ld_core_sct),
      .chn_lut_in_rsci_vd(chn_lut_in_rsci_vd)
    );
  NV_NVDLA_SDP_CORE_Y_idx_core_chn_lut_in_rsci_chn_lut_in_wait_dp NV_NVDLA_SDP_CORE_Y_idx_core_chn_lut_in_rsci_chn_lut_in_wait_dp_inst
      (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_lut_in_rsci_oswt(chn_lut_in_rsci_oswt),
      .chn_lut_in_rsci_bawt(chn_lut_in_rsci_bawt),
      .chn_lut_in_rsci_wen_comp(chn_lut_in_rsci_wen_comp),
      .chn_lut_in_rsci_d_mxwt(chn_lut_in_rsci_d_mxwt),
      .chn_lut_in_rsci_biwt(chn_lut_in_rsci_biwt),
      .chn_lut_in_rsci_bdwt(chn_lut_in_rsci_bdwt),
      .chn_lut_in_rsci_d(chn_lut_in_rsci_d)
    );
endmodule