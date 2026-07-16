//678
module SNPS_CLOCK_GATE_HIGH_RegisterAdd_W32_1_0 ( CLK, EN, ENCLK, TE );
  input CLK, EN, TE;
  output ENCLK;

  reg prev_EN, prev_TE;
  reg set_signal, enable_signal;
  reg ENCLK; // Declare ENCLK as a reg type

  always @(posedge CLK) begin
    // check if TE is rising edge
    if (prev_TE == 0 && TE == 1) begin
      set_signal <= 1;
    end else begin
      set_signal <= 0;
    end

    // check if EN is high
    if (EN == 1) begin
      enable_signal <= 1;
    end else begin
      enable_signal <= 0;
    end

    // check if EN and TE are both high
    if (enable_signal & set_signal) begin
      ENCLK <= CLK;
    end else begin
      ENCLK <= ENCLK; // Hold the previous value of ENCLK
    end

    prev_EN <= EN;
    prev_TE <= TE;
  end
endmodule