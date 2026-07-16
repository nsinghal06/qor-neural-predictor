//1252
module binary_counter(reset, clk, count);
  input reset, clk;
  output reg [3:0] count;

  always @(posedge clk) begin
    if(reset) begin
      count <= 4'b0;
    end else begin
      count <= count + 1;
    end
  end
endmodule