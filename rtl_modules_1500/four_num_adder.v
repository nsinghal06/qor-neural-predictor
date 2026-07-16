//971
module four_num_adder #(
  parameter DELAY_DATA_WIDTH = 16
) (
  input clk,
  input [24:0] data_1,
  input [24:0] data_2,
  input [24:0] data_3,
  input [24:0] data_4,
  input [DELAY_DATA_WIDTH:0] ddata_in,
  output reg [7:0] data_p,
  output reg [DELAY_DATA_WIDTH:0] ddata_out
);

  // Stage 1
  reg [DELAY_DATA_WIDTH:0] p1_ddata = 0;
  reg [24:0] p1_data_1 = 0;
  reg [24:0] p1_data_2 = 0;
  reg [24:0] p1_data_3 = 0;
  reg [24:0] p1_data_4 = 0;
  wire [24:0] p1_data_1_p_s = {1'b0, data_1[23:0]};
  wire [24:0] p1_data_1_n_s = ~p1_data_1_p_s + 1'b1;
  wire [24:0] p1_data_1_s = (data_1[24] == 1'b1) ? p1_data_1_n_s : p1_data_1_p_s;
  wire [24:0] p1_data_2_p_s = {1'b0, data_2[23:0]};
  wire [24:0] p1_data_2_n_s = ~p1_data_2_p_s + 1'b1;
  wire [24:0] p1_data_2_s = (data_2[24] == 1'b1) ? p1_data_2_n_s : p1_data_2_p_s;
  wire [24:0] p1_data_3_p_s = {1'b0, data_3[23:0]};
  wire [24:0] p1_data_3_n_s = ~p1_data_3_p_s + 1'b1;
  wire [24:0] p1_data_3_s = (data_3[24] == 1'b1) ? p1_data_3_n_s : p1_data_3_p_s;
  wire [24:0] p1_data_4_p_s = {1'b0, data_4[23:0]};
  wire [24:0] p1_data_4_n_s = ~p1_data_4_p_s + 1'b1;
  wire [24:0] p1_data_4_s = (data_4[24] == 1'b1) ? p1_data_4_n_s : p1_data_4_p_s;

  always @(posedge clk) begin
    p1_ddata <= ddata_in;
    p1_data_1 <= p1_data_1_s;
    p1_data_2 <= p1_data_2_s;
    p1_data_3 <= p1_data_3_s;
    p1_data_4 <= p1_data_4_s;
  end

  // Stage 2
  reg [DELAY_DATA_WIDTH:0] p2_ddata = 0;
  reg [24:0] p2_data_0 = 0;
  reg [24:0] p2_data_1 = 0;

  always @(posedge clk) begin
    p2_ddata <= p1_ddata;
    p2_data_0 <= p1_data_1 + p1_data_2;
    p2_data_1 <= p1_data_3 + p1_data_4;
  end

  // Stage 3
  reg [DELAY_DATA_WIDTH:0] p3_ddata = 0;
  reg [24:0] p3_data = 0;

  always @(posedge clk) begin
    p3_ddata <= p2_ddata;
    p3_data <= p2_data_0 + p2_data_1;
  end

  always @(posedge clk) begin
    ddata_out <= p3_ddata;
    if (p3_data[24] == 1'b1) begin
      data_p <= 8'h00;
    end else if (p3_data[23:20] == 'd0) begin
      data_p <= p3_data[19:12];
    end else begin
      data_p <= 8'hff;
    end
  end

endmodule