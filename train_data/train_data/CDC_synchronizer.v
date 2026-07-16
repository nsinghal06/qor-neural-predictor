//824
module CDC_synchronizer (
  input Din,
  input Clk_src,
  input Clk_dst,
  input Rst,
  output reg Dout
);

  reg [1:0] ff1;
  reg [1:0] ff2;
  reg pulse;

  always @(posedge Clk_src or negedge Rst) begin
    if (!Rst) begin
      ff1 <= 2'b0;
    end
    else begin
      ff1 <= {ff1[0], Din};
    end
  end

  always @(posedge Clk_dst or negedge Rst) begin
    if (!Rst) begin
      ff2 <= 2'b0;
      pulse <= 1'b0;
    end
    else begin
      ff2 <= {ff2[0], ff1[1]};
      pulse <= 1'b1;
    end
  end

  always @(posedge Clk_dst or negedge Rst) begin
    if (!Rst) begin
      Dout <= 1'b0;
    end
    else begin
      if (pulse) begin
        Dout <= ff2[1];
      end
    end
  end

endmodule