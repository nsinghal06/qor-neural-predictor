module NV_NVDLA_SDP_CORE_Y_idx_core_chn_lut_in_rsci_chn_lut_in_wait_dp (
  nvdla_core_clk, nvdla_core_rstn, chn_lut_in_rsci_oswt, chn_lut_in_rsci_bawt, chn_lut_in_rsci_wen_comp,
      chn_lut_in_rsci_d_mxwt, chn_lut_in_rsci_biwt, chn_lut_in_rsci_bdwt, chn_lut_in_rsci_d
);
  input nvdla_core_clk;
  input nvdla_core_rstn;
  input chn_lut_in_rsci_oswt;
  output chn_lut_in_rsci_bawt;
  output chn_lut_in_rsci_wen_comp;
  output [127:0] chn_lut_in_rsci_d_mxwt;
  input chn_lut_in_rsci_biwt;
  input chn_lut_in_rsci_bdwt;
  input [127:0] chn_lut_in_rsci_d;


  // Interconnect Declarations
  reg chn_lut_in_rsci_bcwt;
  reg [127:0] chn_lut_in_rsci_d_bfwt;


  // Interconnect Declarations for Component Instantiations 
  assign chn_lut_in_rsci_bawt = chn_lut_in_rsci_biwt | chn_lut_in_rsci_bcwt;
  assign chn_lut_in_rsci_wen_comp = (~ chn_lut_in_rsci_oswt) | chn_lut_in_rsci_bawt;
  assign chn_lut_in_rsci_d_mxwt = MUX_v_128_2_2(chn_lut_in_rsci_d, chn_lut_in_rsci_d_bfwt,
      chn_lut_in_rsci_bcwt);
  always @(posedge nvdla_core_clk or negedge nvdla_core_rstn) begin
    if ( ~ nvdla_core_rstn ) begin
      chn_lut_in_rsci_bcwt <= 1'b0;
      chn_lut_in_rsci_d_bfwt <= 128'b0;
    end
    else begin
      chn_lut_in_rsci_bcwt <= ~((~(chn_lut_in_rsci_bcwt | chn_lut_in_rsci_biwt))
          | chn_lut_in_rsci_bdwt);
      chn_lut_in_rsci_d_bfwt <= chn_lut_in_rsci_d_mxwt;
    end
  end

  function [127:0] MUX_v_128_2_2;
    input [127:0] input_0;
    input [127:0] input_1;
    input [0:0] sel;
    reg [127:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_128_2_2 = result;
  end
  endfunction

endmodule