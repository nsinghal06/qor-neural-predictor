module apu_div
#(
  parameter PERIOD_BITS = 4
)
(
  input        clk_in,       // system clock signal
  input        rst_in,       // reset signal
  input        pulse_in,     // input pulse signal
  input        reload_in,    // reload signal
  input  [PERIOD_BITS-1:0] period_in,   // value to count up to
  output       pulse_out      // output pulse signal
);

reg [PERIOD_BITS-1:0] count;

always @(posedge clk_in or posedge rst_in)
begin
  if (rst_in)
    count <= 0;
  else if (reload_in)
    count <= period_in;
  else if (pulse_in)
    count <= count - 1;
end

assign pulse_out = (count == 0);

endmodule