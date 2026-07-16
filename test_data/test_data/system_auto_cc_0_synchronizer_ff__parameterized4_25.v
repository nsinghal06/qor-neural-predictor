//1480
module system_auto_cc_0_synchronizer_ff__parameterized4_25
   (out,
    D,
    Q_reg_reg_0 ,
    m_aclk,
    ngwrdrst_grst_g7serrst_rd_rst_reg_reg_1 );
  output [3:0]out;
  output [0:0]D;
  input [3:0]Q_reg_reg_0 ;
  input m_aclk;
  input [0:0]ngwrdrst_grst_g7serrst_rd_rst_reg_reg_1 ;

  reg [0:0]D_sync_stage1;
  reg [3:0]Q_reg;
  reg [3:0]Q_reg_sync_stage1;
  reg [3:0]Q_reg_sync_stage2;

  assign out[3:0] = Q_reg_sync_stage2;

  always @ (posedge m_aclk or negedge ngwrdrst_grst_g7serrst_rd_rst_reg_reg_1) begin
    if (~ngwrdrst_grst_g7serrst_rd_rst_reg_reg_1) begin
      D_sync_stage1 <= 1'b0;
    end else begin
      D_sync_stage1 <= D;
    end
  end

  always @ (posedge m_aclk or negedge ngwrdrst_grst_g7serrst_rd_rst_reg_reg_1) begin
    if (~ngwrdrst_grst_g7serrst_rd_rst_reg_reg_1) begin
      Q_reg <= 4'b0000;
    end else begin
      Q_reg <= Q_reg_reg_0;
    end
  end

  always @ (posedge m_aclk or negedge ngwrdrst_grst_g7serrst_rd_rst_reg_reg_1) begin
    if (~ngwrdrst_grst_g7serrst_rd_rst_reg_reg_1) begin
      Q_reg_sync_stage1 <= 4'b0000;
    end else begin
      Q_reg_sync_stage1 <= {Q_reg[1:0],D_sync_stage1};
    end
  end

  always @ (posedge m_aclk or negedge ngwrdrst_grst_g7serrst_rd_rst_reg_reg_1) begin
    if (~ngwrdrst_grst_g7serrst_rd_rst_reg_reg_1) begin
      Q_reg_sync_stage2 <= 4'b0000;
    end else begin
      Q_reg_sync_stage2 <= {Q_reg_sync_stage1[2] & Q_reg_sync_stage1[3],Q_reg_sync_stage1[1:0]};
    end
  end
 
  assign D = Q_reg[0] & Q_reg[1] & Q_reg[2] & Q_reg[3];
endmodule