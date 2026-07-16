//958
module byte_swapper(
  input [31:0] in,
  output [31:0] out
);
  assign out = {in[24:16], in[16:8], in[8:0], in[31:24]};
endmodule

module binary_to_bcd(
  input clk,
  input reset,
  input [31:0] binary_in,
  output [3:0] thousands,
  output [3:0] hundreds,
  output [3:0] tens,
  output [3:0] ones
);
  wire [31:0] swapped_binary;
  wire xor_out;

  byte_swapper bs(
    .in(binary_in),
    .out(swapped_binary)
  );

  reg [7:0] th = 8'b00000000;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      th <= 8'b00000000;
    end else begin
      if (xor_out) begin
        th <= swapped_binary[23:16];
      end
    end
  end

  assign thousands = th[3:0];
  assign hundreds = th[7:4];
  assign tens = swapped_binary[23:20];
  assign ones = swapped_binary[15:12];

  xor_gate xg(
    .a(swapped_binary[31]),
    .b(swapped_binary[30]),
    .c(swapped_binary[29]),
    .d(swapped_binary[28]),
    .out(xor_out)
  );
endmodule

module xor_gate(
  input a,
  input b,
  input c,
  input d,
  output reg out
);
  always @(*) begin
    out = a ^ b ^ c ^ d;
  end
endmodule