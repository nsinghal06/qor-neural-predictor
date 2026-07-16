//1031
module d_flip_flop (
    input wire clk,
    input wire d,
    output reg q
);

reg j, k;

always @(posedge clk) begin
    j <= d;
    k <= ~d;
    q <= j ^ (q & k);
end

endmodule

module byte_reversal (
    input wire [31:0] in,
    output wire [31:0] out
);

assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule

module xor_module (
    input wire [31:0] in1,
    input wire [31:0] in2,
    output reg led
);

always @(*) begin
    led = in1 ^ in2;
end

endmodule

module top_module (
    input  wire clk,
    input  wire [31:0] in,
    output wire [31:0] out,
    output wire led,
    input  wire d,
    output reg q
);

wire [31:0] reversed_in;

byte_reversal byte_reversal_inst (
    .in(in),
    .out(reversed_in)
);

d_flip_flop d_flip_flop_inst (
    .clk(clk),
    .d(d),
    .q(q)
);

xor_module xor_module_inst (
    .in1(reversed_in),
    .in2({32{q}}),
    .led(led)
);

assign out = reversed_in;

endmodule