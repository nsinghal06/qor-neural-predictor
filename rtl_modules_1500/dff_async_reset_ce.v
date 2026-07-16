//1237
module dff_async_reset_ce(
  input D, CLK, DE, RESET,
  output Q
);

  reg Q;

  always @(posedge CLK, negedge RESET) begin
    if(!RESET) begin
      Q <= 0;
    end else if(DE) begin
      Q <= D;
    end
  end

endmodule