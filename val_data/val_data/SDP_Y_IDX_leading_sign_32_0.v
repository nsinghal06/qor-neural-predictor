module SDP_Y_IDX_leading_sign_32_0 (
  mantissa, rtn
);
  input [31:0] mantissa;
  output [5:0] rtn;


  // Interconnect Declarations
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_6_2_sdt_2;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_18_3_sdt_3;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_26_2_sdt_2;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_42_4_sdt_4;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_50_2_sdt_2;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_62_3_sdt_3;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_70_2_sdt_2;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_92_5_sdt_5;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_6_2_sdt_1;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_14_2_sdt_1;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_26_2_sdt_1;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_34_2_sdt_1;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_50_2_sdt_1;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_58_2_sdt_1;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_70_2_sdt_1;
  wire IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_78_2_sdt_1;
  wire c_h_1_2;
  wire c_h_1_5;
  wire c_h_1_6;
  wire c_h_1_9;
  wire c_h_1_12;
  wire c_h_1_13;
  wire c_h_1_14;

  wire[4:0] IntLeadZero_32U_leading_sign_32_0_rtn_IntLeadZero_32U_leading_sign_32_0_rtn_and_nl;
  wire[0:0] IntLeadZero_32U_leading_sign_32_0_rtn_and_119_nl;
  wire[0:0] IntLeadZero_32U_leading_sign_32_0_rtn_and_117_nl;
  wire[0:0] IntLeadZero_32U_leading_sign_32_0_rtn_and_124_nl;
  wire[0:0] IntLeadZero_32U_leading_sign_32_0_rtn_and_127_nl;
  wire[0:0] IntLeadZero_32U_leading_sign_32_0_rtn_not_nl;

  // Interconnect Declarations for Component Instantiations 
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_6_2_sdt_2 = ~((mantissa[29:28]!=2'b00));
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_6_2_sdt_1 = ~((mantissa[31:30]!=2'b00));
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_14_2_sdt_1 = ~((mantissa[27:26]!=2'b00));
  assign c_h_1_2 = IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_6_2_sdt_1 & IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_6_2_sdt_2;
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_18_3_sdt_3 = (mantissa[25:24]==2'b00)
      & IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_14_2_sdt_1;
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_26_2_sdt_2 = ~((mantissa[21:20]!=2'b00));
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_26_2_sdt_1 = ~((mantissa[23:22]!=2'b00));
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_34_2_sdt_1 = ~((mantissa[19:18]!=2'b00));
  assign c_h_1_5 = IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_26_2_sdt_1 & IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_26_2_sdt_2;
  assign c_h_1_6 = c_h_1_2 & IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_18_3_sdt_3;
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_42_4_sdt_4 = (mantissa[17:16]==2'b00)
      & IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_34_2_sdt_1 & c_h_1_5;
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_50_2_sdt_2 = ~((mantissa[13:12]!=2'b00));
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_50_2_sdt_1 = ~((mantissa[15:14]!=2'b00));
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_58_2_sdt_1 = ~((mantissa[11:10]!=2'b00));
  assign c_h_1_9 = IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_50_2_sdt_1 & IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_50_2_sdt_2;
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_62_3_sdt_3 = (mantissa[9:8]==2'b00)
      & IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_58_2_sdt_1;
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_70_2_sdt_2 = ~((mantissa[5:4]!=2'b00));
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_70_2_sdt_1 = ~((mantissa[7:6]!=2'b00));
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_78_2_sdt_1 = ~((mantissa[3:2]!=2'b00));
  assign c_h_1_12 = IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_70_2_sdt_1 & IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_70_2_sdt_2;
  assign c_h_1_13 = c_h_1_9 & IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_62_3_sdt_3;
  assign c_h_1_14 = c_h_1_6 & IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_42_4_sdt_4;
  assign IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_92_5_sdt_5 = (mantissa[1:0]==2'b00)
      & IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_78_2_sdt_1 & c_h_1_12 & c_h_1_13
      & c_h_1_14;
  assign IntLeadZero_32U_leading_sign_32_0_rtn_and_119_nl = c_h_1_6 & (c_h_1_13 |
      (~ IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_42_4_sdt_4));
  assign IntLeadZero_32U_leading_sign_32_0_rtn_and_117_nl = c_h_1_2 & (c_h_1_5 |
      (~ IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_18_3_sdt_3)) & (~((~(c_h_1_9
      & (c_h_1_12 | (~ IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_62_3_sdt_3))))
      & c_h_1_14));
  assign IntLeadZero_32U_leading_sign_32_0_rtn_and_124_nl = IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_6_2_sdt_1
      & (IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_14_2_sdt_1 | (~ IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_6_2_sdt_2))
      & (~((~(IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_26_2_sdt_1 & (IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_34_2_sdt_1
      | (~ IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_26_2_sdt_2)))) & c_h_1_6))
      & (~((~(IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_50_2_sdt_1 & (IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_58_2_sdt_1
      | (~ IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_50_2_sdt_2)) & (~((~(IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_70_2_sdt_1
      & (IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_78_2_sdt_1 | (~ IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_70_2_sdt_2))))
      & c_h_1_13)))) & c_h_1_14));
  assign IntLeadZero_32U_leading_sign_32_0_rtn_and_127_nl = (~((mantissa[31]) | (~((mantissa[30:29]!=2'b01)))))
      & (~(((mantissa[27]) | (~((mantissa[26:25]!=2'b01)))) & c_h_1_2)) & (~((~((~((mantissa[23])
      | (~((mantissa[22:21]!=2'b01))))) & (~(((mantissa[19]) | (~((mantissa[18:17]!=2'b01))))
      & c_h_1_5)))) & c_h_1_6)) & (~((~((~((mantissa[15]) | (~((mantissa[14:13]!=2'b01)))))
      & (~(((mantissa[11]) | (~((mantissa[10:9]!=2'b01)))) & c_h_1_9)) & (~((~((~((mantissa[7])
      | (~((mantissa[6:5]!=2'b01))))) & (~(((mantissa[3]) | (~((mantissa[2:1]!=2'b01))))
      & c_h_1_12)))) & c_h_1_13)))) & c_h_1_14));
  assign IntLeadZero_32U_leading_sign_32_0_rtn_not_nl = ~ IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_92_5_sdt_5;
  assign IntLeadZero_32U_leading_sign_32_0_rtn_IntLeadZero_32U_leading_sign_32_0_rtn_and_nl
      = MUX_v_5_2_2(5'b00000, ({c_h_1_14 , (IntLeadZero_32U_leading_sign_32_0_rtn_and_119_nl)
      , (IntLeadZero_32U_leading_sign_32_0_rtn_and_117_nl) , (IntLeadZero_32U_leading_sign_32_0_rtn_and_124_nl)
      , (IntLeadZero_32U_leading_sign_32_0_rtn_and_127_nl)}), (IntLeadZero_32U_leading_sign_32_0_rtn_not_nl));
  assign rtn = {IntLeadZero_32U_leading_sign_32_0_rtn_wrs_c_92_5_sdt_5 , (IntLeadZero_32U_leading_sign_32_0_rtn_IntLeadZero_32U_leading_sign_32_0_rtn_and_nl)};

  function [4:0] MUX_v_5_2_2;
    input [4:0] input_0;
    input [4:0] input_1;
    input [0:0] sel;
    reg [4:0] result;
  begin
    case (sel)
      1'b0 : begin
        result = input_0;
      end
      default : begin
        result = input_1;
      end
    endcase
    MUX_v_5_2_2 = result;
  end
  endfunction

endmodule