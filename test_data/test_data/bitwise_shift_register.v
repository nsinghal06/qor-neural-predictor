//147
module bitwise_shift_register (
    input [99:0] in,
    output [99:0] shift_out,
    output [99:0] and_out,
    input clk
);

reg [99:0] shift_reg;

assign shift_out = shift_reg;
assign and_out = shift_reg & 100'hFFFFF;

always @(posedge clk) begin
    shift_reg <= {shift_reg[98:0], in[0]};
end

endmodule

module edge_detection (
    input clk,
    input [7:0] in,
    output reg [7:0] out
);

reg [7:0] prev_in;

always @(posedge clk) begin
    if (in != prev_in) begin
        out <= (in & ~prev_in);
    end
    prev_in <= in;
end

endmodule

module bitwise_xor (
    input [7:0] in1,
    input [7:0] in2,
    output [7:0] out
);

assign out = in1 ^ in2;

endmodule

module top_module (
    input clk,
    input [99:0] in1,
    input [7:0] in2,
    output [7:0] out
);

wire [99:0] shift_out;
wire [99:0] and_out;
wire [7:0] edge_out;

bitwise_shift_register shift_reg (
    .in(in1),
    .shift_out(shift_out),
    .and_out(and_out),
    .clk(clk)
);

edge_detection edge_det (
    .clk(clk),
    .in(in2),
    .out(edge_out)
);

bitwise_xor xor_op (
    .in1(shift_out[7:0]),
    .in2(edge_out),
    .out(out)
);

endmodule