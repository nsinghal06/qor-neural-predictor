//1117
module ClockGate(
  input clk,
  input en,
  input te,
  output reg enclk
);

  always @ (posedge clk) begin
    if (en) begin
      if (te) begin
        enclk <= 1'b0;
      end else begin
        enclk <= clk;
      end
    end else begin
      enclk <= 1'b0;
    end
  end

endmodule