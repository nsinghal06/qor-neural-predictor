module NV_NVDLA_SDP_CORE_Y_idx (
  nvdla_core_clk, nvdla_core_rstn, chn_lut_in_rsc_z, chn_lut_in_rsc_vz, chn_lut_in_rsc_lz,
      cfg_lut_le_start_rsc_z, cfg_lut_lo_start_rsc_z, cfg_lut_le_index_offset_rsc_z,
      cfg_lut_le_index_select_rsc_z, cfg_lut_lo_index_select_rsc_z, cfg_lut_le_function_rsc_z,
      cfg_lut_uflow_priority_rsc_z, cfg_lut_oflow_priority_rsc_z, cfg_lut_hybrid_priority_rsc_z,
      cfg_precision_rsc_z, chn_lut_out_rsc_z, chn_lut_out_rsc_vz, chn_lut_out_rsc_lz
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input [127:0] chn_lut_in_rsc_z;
  input chn_lut_in_rsc_vz;
  output chn_lut_in_rsc_lz;
  input [31:0] cfg_lut_le_start_rsc_z;
  input [31:0] cfg_lut_lo_start_rsc_z;
  input [7:0] cfg_lut_le_index_offset_rsc_z;
  input [7:0] cfg_lut_le_index_select_rsc_z;
  input [7:0] cfg_lut_lo_index_select_rsc_z;
  input cfg_lut_le_function_rsc_z;
  input cfg_lut_uflow_priority_rsc_z;
  input cfg_lut_oflow_priority_rsc_z;
  input cfg_lut_hybrid_priority_rsc_z;
  input [1:0] cfg_precision_rsc_z;
  output [323:0] chn_lut_out_rsc_z;
  input chn_lut_out_rsc_vz;
  output chn_lut_out_rsc_lz;


  // Interconnect Declarations
  wire chn_lut_in_rsci_oswt;
  wire chn_lut_in_rsci_oswt_unreg;
  wire chn_lut_out_rsci_oswt;
  wire chn_lut_out_rsci_oswt_unreg;


  // Interconnect Declarations for Component Instantiations 
  SDP_Y_IDX_chn_lut_in_rsci_unreg chn_lut_in_rsci_unreg_inst (
      .in_0(chn_lut_in_rsci_oswt_unreg),
      .outsig(chn_lut_in_rsci_oswt)
    );
  SDP_Y_IDX_chn_lut_out_rsci_unreg chn_lut_out_rsci_unreg_inst (
      .in_0(chn_lut_out_rsci_oswt_unreg),
      .outsig(chn_lut_out_rsci_oswt)
    );
  NV_NVDLA_SDP_CORE_Y_idx_core NV_NVDLA_SDP_CORE_Y_idx_core_inst (
      .nvdla_core_clk(nvdla_core_clk),
      .nvdla_core_rstn(nvdla_core_rstn),
      .chn_lut_in_rsc_z(chn_lut_in_rsc_z),
      .chn_lut_in_rsc_vz(chn_lut_in_rsc_vz),
      .chn_lut_in_rsc_lz(chn_lut_in_rsc_lz),
      .cfg_lut_le_start_rsc_z(cfg_lut_le_start_rsc_z),
      .cfg_lut_lo_start_rsc_z(cfg_lut_lo_start_rsc_z),
      .cfg_lut_le_index_offset_rsc_z(cfg_lut_le_index_offset_rsc_z),
      .cfg_lut_le_index_select_rsc_z(cfg_lut_le_index_select_rsc_z),
      .cfg_lut_lo_index_select_rsc_z(cfg_lut_lo_index_select_rsc_z),
      .cfg_lut_le_function_rsc_z(cfg_lut_le_function_rsc_z),
      .cfg_lut_uflow_priority_rsc_z(cfg_lut_uflow_priority_rsc_z),
      .cfg_lut_oflow_priority_rsc_z(cfg_lut_oflow_priority_rsc_z),
      .cfg_lut_hybrid_priority_rsc_z(cfg_lut_hybrid_priority_rsc_z),
      .cfg_precision_rsc_z(cfg_precision_rsc_z),
      .chn_lut_out_rsc_z(chn_lut_out_rsc_z),
      .chn_lut_out_rsc_vz(chn_lut_out_rsc_vz),
      .chn_lut_out_rsc_lz(chn_lut_out_rsc_lz),
      .chn_lut_in_rsci_oswt(chn_lut_in_rsci_oswt),
      .chn_lut_in_rsci_oswt_unreg(chn_lut_in_rsci_oswt_unreg),
      .chn_lut_out_rsci_oswt(chn_lut_out_rsci_oswt),
      .chn_lut_out_rsci_oswt_unreg(chn_lut_out_rsci_oswt_unreg)
    );
endmodule