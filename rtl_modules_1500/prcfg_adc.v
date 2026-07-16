//84
module prcfg_adc (
  clk,

  // control ports
  control,
  status,

  // FIFO interface
  src_adc_enable,
  src_adc_valid,
  src_adc_data,

  dst_adc_enable,
  dst_adc_valid,
  dst_adc_data
);

  localparam  RP_ID       = 8'hA1;
  parameter   CHANNEL_ID  = 0;

  input             clk;

  input   [31:0]    control;
  output  [31:0]    status;

  input             src_adc_enable;
  input             src_adc_valid;
  input   [15:0]    src_adc_data;

  output            dst_adc_enable;
  output            dst_adc_valid;
  output  [15:0]    dst_adc_data;

  reg               dst_adc_enable;
  reg               dst_adc_valid;
  reg     [15:0]    dst_adc_data;

  reg     [31:0]    status            = 0;
  reg     [15:0]    adc_pn_data       = 0;

  reg     [ 3:0]    mode;
  reg     [ 3:0]    channel_sel;

  wire              adc_dvalid;
  wire    [15:0]    adc_pn_data_s;
  wire              adc_pn_oos_s;
  wire              adc_pn_err_s;

  // prbs function

  function [15:0] pn;
    input [15:0] din;
    reg   [15:0] dout;
    begin
      dout[15] = din[14] ^ din[15];
      dout[14] = din[13] ^ din[14];
      dout[13] = din[12] ^ din[13];
      dout[12] = din[11] ^ din[12];
      dout[11] = din[10] ^ din[11];
      dout[10] = din[ 9] ^ din[10];
      dout[ 9] = din[ 8] ^ din[ 9];
      dout[ 8] = din[ 7] ^ din[ 8];
      dout[ 7] = din[ 6] ^ din[ 7];
      dout[ 6] = din[ 5] ^ din[ 6];
      dout[ 5] = din[ 4] ^ din[ 5];
      dout[ 4] = din[ 3] ^ din[ 4];
      dout[ 3] = din[ 2] ^ din[ 3];
      dout[ 2] = din[ 1] ^ din[ 2];
      dout[ 1] = din[ 0] ^ din[ 1];
      dout[ 0] = din[14] ^ din[15] ^ din[ 0];
      pn = dout;
    end
  endfunction

  assign adc_dvalid = src_adc_enable & src_adc_valid;

  always @(posedge clk) begin
    channel_sel  <= control[3:0];
    mode         <= control[7:4];
  end

  // prbs generation
  always @(posedge clk) begin
    if(adc_dvalid == 1'b1) begin
      adc_pn_data <= pn(adc_pn_data_s);
    end
  end

  assign adc_pn_data_s = (adc_pn_oos_s == 1'b1) ? src_adc_data : adc_pn_data;

  ad_pnmon #(
    .DATA_WIDTH(16)
  ) i_pn_mon (
    .adc_clk(clk),
    .adc_valid_in(adc_dvalid),
    .adc_data_in(src_adc_data),
    .adc_data_pn(adc_pn_data),
    .adc_pn_oos(adc_pn_oos_s),
    .adc_pn_err(adc_pn_err_s));

  // rx path are passed through on test mode
  always @(posedge clk) begin
    dst_adc_enable <= src_adc_enable;
    dst_adc_data   <= src_adc_data;
    dst_adc_valid  <= src_adc_valid;
  end

  // setup status bits for gpio_out
  always @(posedge clk) begin
    if((mode == 3'd2) && (channel_sel == CHANNEL_ID)) begin
      status <= {23'h0, adc_pn_err_s, adc_pn_oos_s, RP_ID};
    end else begin
      status <= {24'h0, RP_ID};
    end
  end

endmodule

module ad_pnmon (
  adc_clk,
  adc_valid_in,
  adc_data_in,
  adc_data_pn,
  adc_pn_oos,
  adc_pn_err
);

  input              adc_clk;
  input              adc_valid_in;
  input   [15:0]    adc_data_in;
  input   [15:0]    adc_data_pn;
  output             adc_pn_oos;
  output             adc_pn_err;

  parameter DATA_WIDTH = 16;

  reg     [DATA_WIDTH-1:0]    pn_data;
  reg               pn_oos;
  reg               pn_err;

  // PN Generator

  always @(posedge adc_clk) begin
    if(adc_valid_in == 1'b1) begin
      pn_data <= pn_data ^ adc_data_in;
    end
  end

  // PN Verifier

  always @(posedge adc_clk) begin
    if(adc_valid_in == 1'b1) begin
      pn_oos <= (pn_data != adc_data_pn);
    end
  end

  // Error Extraction

  always @(*) begin
    pn_err   = (pn_oos == 1'b1) & (adc_data_in != {DATA_WIDTH{1'b0}});
  end

  assign adc_pn_oos = pn_oos;
  assign adc_pn_err = pn_err;

endmodule