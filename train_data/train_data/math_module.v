//48
module math_module(a_in, b_in, c_in, d_in, e_in, f_in, out0, out1, out2, out3, out4);
  parameter BITS = 8;
  parameter B2TS = BITS*2;
  parameter B2TS_MINUS_1 = B2TS-1;
  parameter BITS_MINUS_1 = BITS-1;
  parameter BITS_MINUS_2 = BITS-2;
  parameter BITS_MINUS_3 = BITS-3;

  input [BITS_MINUS_1:0] a_in;
  input [BITS_MINUS_1:0] b_in;
  input [BITS_MINUS_1:0] c_in;
  input [BITS_MINUS_1:0] d_in;
  input [BITS_MINUS_1:0] e_in;
  input [BITS_MINUS_2:0] f_in;

  output [B2TS_MINUS_1:0] out0;
  output [B2TS_MINUS_1:0] out1;
  output [B2TS_MINUS_1:0] out2;
  output [14:0] out3;
  output [14:0] out4;

  assign out1 = c_in * d_in;
  assign out4 = f_in * e_in;

  wire [BITS_MINUS_1:0] temp_a;
  wire [BITS_MINUS_1:0] temp_b;
  wire temp_c;
  wire temp_d;

  assign temp_c = a_in[7] & b_in[7];
  assign temp_d = a_in[6] & b_in[6];

  assign out2 = {temp_d, temp_c} & {a_in[5:0], b_in[5:0]};

  assign out3 = e_in * {{1{1'b0}}, f_in};

  assign out0 = {a_in, b_in} * {{1{1'b0}}, {1'b0, 1'b0, f_in}};

endmodule