//1134
module d_ff_en_clr
  (
   output reg [31:0] Q,
   input E,
   input [31:0] D,
   input CLK,
   input CLR
   );

  always @ (posedge CLK) begin
    if (CLR == 1'b1) begin
      Q <= 32'b0;
    end else if (E == 1'b1) begin
      Q <= D;
    end
  end

endmodule