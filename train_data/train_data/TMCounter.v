//383
module TMCounter
  #(
    parameter CNT_PRESC=24,
    parameter ENA_TMR=1
   )
   (
    input        wb_clk_i, input        wb_rst_i, input  [2:0] wb_adr_i, output [7:0] wb_dat_o, input  [7:0] wb_dat_i, input        wb_we_i,  input        wb_stb_i, output       wb_ack_o, output [5:0] pwm_o,    output [5:0] pwm_e_o   );

localparam integer CNT_BITS=$clog2(CNT_PRESC);

reg  [31:0] cnt_us_r=0;
reg  [9:0]  cnt_us2_r=0;
wire tc_cnt_us2;
reg  [31:0] cnt_ms_r=0;
reg  [31:0] latched_r=0;
wire ena_cnt;
reg  [CNT_BITS-1:0] pre_cnt_r;
reg  [7:0] cnt_blk_r=0;
wire ena_blk_cnt;
reg  [CNT_BITS-1:0] pre_bk_r;
localparam IDLE=0, DELAY=1; reg  state;
wire blk_we;
reg  [7:0] pwm_val_r[0:5];
wire [7:0] pwm_count;
reg  [7:0] wb_dat; reg  [5:0] pwm_e_r;

always @(posedge wb_clk_i)
begin : tmr_prescaler
  if (wb_rst_i)
     pre_cnt_r <= 0;
  else
     begin
     pre_cnt_r <= pre_cnt_r+1;
     if (pre_cnt_r==CNT_PRESC-1)
        pre_cnt_r <= 0;
     end
end assign ena_cnt=pre_cnt_r==CNT_PRESC-1;

always @(posedge wb_clk_i)
begin : do_cnt_us
  if (wb_rst_i)
     cnt_us_r <= 0;
  else if (ena_cnt)
     cnt_us_r <= cnt_us_r+1;
end always @(posedge wb_clk_i)
begin : do_cnt_us2
  if (wb_rst_i || tc_cnt_us2)
     cnt_us2_r <= 0;
  else if (ena_cnt)
     cnt_us2_r <= cnt_us2_r+1;
end assign tc_cnt_us2=cnt_us2_r==999 && ena_cnt;

always @(posedge wb_clk_i)
begin : do_cnt_ms
  if (wb_rst_i)
     cnt_ms_r <= 0;
  else if (tc_cnt_us2)
     cnt_ms_r <= cnt_ms_r+1;
end always @(posedge wb_clk_i)
begin : do_cnt_usr
  if (wb_rst_i)
     latched_r <= 0;
  else if (wb_stb_i)
     begin
     if (wb_adr_i==3'b0)
        latched_r <= cnt_us_r;
     else if (wb_adr_i==3'b100)
        latched_r <= cnt_ms_r;
     end
end always @(wb_adr_i or cnt_us_r or latched_r or cnt_ms_r)
begin
  case (wb_adr_i)
    3'b000:  wb_dat= cnt_us_r[ 7: 0];
    3'b001:  wb_dat=latched_r[15: 8];
    3'b010:  wb_dat=latched_r[23:16];
    3'b011:  wb_dat=latched_r[31:24];
    3'b100:  wb_dat= cnt_ms_r[ 7: 0];
    3'b101:  wb_dat=latched_r[15: 8];
    3'b110:  wb_dat=latched_r[23:16];
    3'b111:  wb_dat=latched_r[31:24];
    default: wb_dat=0;
  endcase
end
assign wb_dat_o=ENA_TMR ? wb_dat : 0;

assign blk_we=wb_stb_i && wb_we_i && wb_adr_i==3'b111 && ENA_TMR;

assign wb_ack_o=wb_stb_i && (!blk_we || (state==DELAY && cnt_blk_r==0));

always @(posedge wb_clk_i)
begin : do_fsm
  if (wb_rst_i)
     state <= IDLE;
  else
     if (state==IDLE)
        begin
        if (blk_we)
           state <= DELAY;
        end
     else begin
        if (!cnt_blk_r)
           state <= IDLE;
        end
end always @(posedge wb_clk_i)
begin : do_bk_cnt
  if (wb_rst_i)
     cnt_blk_r <= 0;
  else if (state==IDLE && blk_we)
     cnt_blk_r <= wb_dat_i;
  else if (ena_blk_cnt)
     cnt_blk_r <= cnt_blk_r-1;
end always @(posedge wb_clk_i)
begin : tmr_prescaler_bk
  if (wb_rst_i || (state==IDLE && blk_we))
     pre_bk_r <= CNT_PRESC-1;
  else
     begin
     pre_bk_r <= pre_bk_r-1;
     if (!pre_bk_r)
        pre_bk_r <= CNT_PRESC-1;
     end
end assign ena_blk_cnt=pre_bk_r==0;

always @(posedge wb_clk_i)
begin : do_pwm_val_write
  if (!wb_rst_i && wb_stb_i && wb_we_i &&
      wb_adr_i!=3'b111 && wb_adr_i!=3'b110)
     pwm_val_r[wb_adr_i] <= wb_dat_i;
end assign pwm_count=cnt_us_r[9:2];

genvar i;
generate  
for (i=0; i<=5; i=i+1)
  begin: do_pwm_outs
  assign pwm_o[i]=pwm_count<=pwm_val_r[i];
  end  
endgenerate

always @(posedge wb_clk_i)
begin : do_pwm_ena_write
  if (wb_rst_i)
     pwm_e_r <= 0;
  else
     if (wb_stb_i && wb_we_i && wb_adr_i==3'b110)
        pwm_e_r <= wb_dat_i[5:0];
end assign pwm_e_o=pwm_e_r;

endmodule