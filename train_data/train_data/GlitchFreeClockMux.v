//1332
module GlitchFreeClockMux (
  input [n-1:0] clk,
  input sel,
  output reg out
);

parameter n = 4; // number of clock signals

reg [n-1:0] sync_clk;
reg [n-1:0] delay_clk;
reg prev_clk;

always @ (*) begin
  sync_clk = sel ? {clk[1], clk[2], clk[3]} : {clk[0], clk[2], clk[3]};
  delay_clk = sel ? {clk[0], clk[2], clk[3]} : {clk[1], clk[2], clk[3]};
  prev_clk = sel ? clk[1] : clk[0];
end

always @ (posedge sync_clk[0]) begin
  // Only update 'out' when the clock transition is from 'prev_clk' to 'sync_clk[0]'
  if (prev_clk != sync_clk[0]) begin
    out <= delay_clk[0];
  end
end

endmodule