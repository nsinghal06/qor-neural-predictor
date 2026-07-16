//162
module DDC (
  input [31:0] in_real,
  input [31:0] in_imag,
  input [31:0] f_shift,
  input [31:0] fs,
  output reg [31:0] out_real,
  output reg [31:0] out_imag
);
  parameter f_max = 64'd2062524897; // Sampling frequency in Hz

  wire [31:0] magnitude2;
  wire [31:0] p_real, p_imag;
  wire [63:0] p_real64, p_imag64;

  assign magnitude2 = (in_real * in_real) + (in_imag * in_imag);
  assign p_real64 = (in_imag * f_max) * 64'd16777216;
  assign p_imag64 = (in_real * f_max) * 64'd16777216;
  assign p_real = p_real64[31:0];
  assign p_imag = p_imag64[31:0];

  always @(*) begin
    out_real = (magnitude2 * p_real) >> 32'd31;
    out_imag = (magnitude2 * p_imag) >> 32'd31;
  end
endmodule

module DUC (
  input [31:0] in_real,
  input [31:0] in_imag,
  input [31:0] f_shift,
  input [31:0] fs,
  output reg [31:0] out_real,
  output reg [31:0] out_imag
);
  parameter f_max = 64'd2062524897; // Sampling frequency in Hz

  wire [31:0] magnitude2;
  wire [31:0] p_real, p_imag;
  wire [63:0] p_real64, p_imag64;

  assign magnitude2 = (in_real * in_real) + (in_imag * in_imag);
  assign p_real64 = (in_imag * f_max) * 64'd16777216;
  assign p_imag64 = (in_real * f_max) * 64'd16777216;
  assign p_real = p_real64[31:0];
  assign p_imag = p_imag64[31:0];

  always @(*) begin
    out_real = (magnitude2 * p_real) >> 32'd31;
    out_imag = (magnitude2 * p_imag) >> 32'd31;
  end
endmodule