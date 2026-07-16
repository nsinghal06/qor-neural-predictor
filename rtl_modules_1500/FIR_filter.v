//1119
module FIR_filter (
  input clk,
  input rst,
  input [15:0] in, // input sample
  input [15:0] coeff, // filter coefficients
  output [15:0] out // output sample
);

parameter n = 128; // number of input/output samples
parameter m = 16; // number of filter coefficients

reg [15:0] shift_reg [m-1:0]; // shift register to store input samples
reg [15:0] out_reg; // register to store output sample
integer i, j;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    out_reg <= 0;
    for (i = 0; i < m; i = i + 1) begin
      shift_reg[i] <= 0;
    end
  end else begin
    // Shift input sample into shift register
    shift_reg[0] <= in;

    // Shift other samples in shift register
    for (i = 1; i < m; i = i + 1) begin
      shift_reg[i] <= shift_reg[i - 1];
    end

    // Calculate output sample
    out_reg <= 0;
    for (i = 0; i < m; i = i + 1) begin
      out_reg <= out_reg + (shift_reg[i] * coeff[i]);
    end
  end
end

assign out = out_reg;

endmodule