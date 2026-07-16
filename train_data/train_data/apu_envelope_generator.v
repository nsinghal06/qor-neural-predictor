//1167
module apu_envelope_generator
(
  input        clk_in,       // system clock signal
  input        rst_in,       // reset signal
  input        eg_pulse_in,  // 1 clk pulse for every env gen update
  input  [5:0] env_in,       // envelope value (e.g., via $4000)
  input        env_wr_in,    // envelope value write
  input        env_restart,  // envelope restart
  output [3:0] env_out       // output volume
);

reg  [5:0] q_reg;
wire [5:0] d_reg;
reg  [3:0] q_cnt,        d_cnt;
reg        q_start_flag, d_start_flag;

// Register the current envelope value and counter value on each clock cycle
always @(posedge clk_in)
  begin
    if (rst_in)
      begin
        q_reg        <= 6'h00;
        q_cnt        <= 4'h0;
        q_start_flag <= 1'b0;
      end
    else
      begin
        q_reg        <= d_reg;
        q_cnt        <= d_cnt;
        q_start_flag <= d_start_flag;
      end
  end

// Instantiate a divider module that generates a clock signal
reg  divider_pulse_in;
reg  divider_reload;
wire divider_pulse_out;

apu_div divider(
  .clk_in(clk_in),
  .rst_in(rst_in),
  .pulse_in(divider_pulse_in),
  .reload_in(divider_reload),
  .period_in(q_reg[3:0]),
  .pulse_out(divider_pulse_out)
);

// Update the counter and start flag based on the divider and envelope pulse inputs
always @*
  begin
    d_cnt        = q_cnt;
    d_start_flag = q_start_flag;

    divider_pulse_in = 1'b0;
    divider_reload   = 1'b0;

    if (divider_pulse_out)
      begin
        divider_reload = 1'b1;

        if (q_cnt != 4'h0)
          d_cnt = q_cnt - 4'h1;
        else if (q_reg[5])
          d_cnt = 4'hF;
      end

    if (eg_pulse_in)
      begin
        if (q_start_flag == 1'b0)
          begin
            divider_pulse_in = 1'b1;
          end
        else
          begin
            d_start_flag = 1'b0;
            d_cnt        = 4'hF;
          end
      end

    if (env_restart)
      d_start_flag = 1'b1;
  end

// Update the envelope value based on the envelope write input
assign d_reg = (env_wr_in) ? env_in : q_reg;

// Calculate the envelope output based on the constant volume flag
assign env_out = (q_reg[4]) ? q_reg[3:0] : q_cnt;

endmodule

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