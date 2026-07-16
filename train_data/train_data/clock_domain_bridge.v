//847
module clock_domain_bridge(
  input bus_clk, input bus_rst,
  input ce_clk, input ce_rst,
  input  [63:0] i_tdata, input  i_tlast, input  i_tvalid, output i_tready,
  output [63:0] o_tdata, output o_tlast, output o_tvalid, input  o_tready
);

  // Bridge input data from bus_clk domain to ce_clk domain
  reg [63:0] i_tdata_ce;
  always @(posedge ce_clk) begin
    if (!ce_rst) begin
      i_tdata_ce <= 0;
    end else if (i_tvalid) begin
      i_tdata_ce <= i_tdata;
    end
  end

  // Instantiate addsub module
  // Addsub module declaration needs to be corrected
  // Assuming addsub is a module with input and output ports defined elsewhere
  // Correct instantiation is provided below
  // addsub inst_addsub_hls (
  //   .ap_clk(ce_clk), .ap_rst_n(~ce_rst),
  //   .a_TDATA(i_tdata_ce), .a_TVALID(i_tvalid), .a_TREADY(),
  //   .b_TDATA(64'h0000000000000001), .b_TVALID(1'b1), .b_TREADY(),
  //   .add_TDATA(o_tdata), .add_TVALID(o_tvalid), .add_TLAST(o_tlast),
  //   .sub_TDATA(), .sub_TVALID(), .sub_TLAST());

  // Output data when o_tready is high
  reg [63:0] o_tdata_ce;
  reg o_tvalid_ce, o_tlast_ce;
  always @(posedge ce_clk) begin
    if (!ce_rst) begin
      o_tdata_ce <= 0;
      o_tvalid_ce <= 0;
      o_tlast_ce <= 0;
    end else if (o_tready && o_tvalid_ce) begin
      o_tvalid_ce <= 0;
      o_tlast_ce <= 0;
    end else if (o_tready && !o_tvalid_ce && o_tvalid) begin
      o_tdata_ce <= o_tdata;
      o_tvalid_ce <= 1;
      o_tlast_ce <= i_tlast;
    end
  end

  assign i_tready = 1;
  assign o_tdata = o_tdata_ce;
  assign o_tvalid = o_tvalid_ce;
  assign o_tlast = o_tlast_ce;

endmodule