//1154
module VCO_interface (
  input clk,
  input vin,
  output out
);

parameter f0 = 100000; // nominal frequency of VCO
parameter k = 100; // tuning sensitivity of VCO

reg out_reg;
reg [31:0] counter;

always @(posedge clk) begin
  counter <= counter + 1;
  if (counter >= (f0 + k * vin) / 2) begin
    out_reg <= ~out_reg;
    counter <= 0;
  end
end

assign out = out_reg;

endmodule