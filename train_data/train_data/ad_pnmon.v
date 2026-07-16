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