//1387
module test(
  input clk,
  input rstn,
  input [3:0] a,
  input [3:0] b,
  output reg status,
  output reg [31:0] c
);

  reg [2:0] ab;
  reg [31:0] c_temp;

  always @(*) begin
    ab = {b[1],a[3:2]};
  end

  always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      status <= 1'b0;
      c <= 32'h0;
    end else begin
      if (ab == 3'b001) begin
        status <= 1'b1;
        c_temp <= 16'hFFFF;
      end else begin
        status <= 1'b0;
        c_temp <= c;
      end
      c <= c_temp;
    end
  end

endmodule