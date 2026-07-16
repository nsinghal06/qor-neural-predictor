//662
module byte_reversal (
    input [31:0] in,
    output [31:0] out
);

assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule

module up_counter (
    input clk,
    input reset,
    input ena,
    output reg [15:0] count
);

parameter MAX_COUNT = 15535;
reg [15:0] next_count;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
    end else if (ena) begin
        count <= next_count;
    end
end

always @(*) begin
    if (count == MAX_COUNT) begin
        next_count = 0;
    end else if (ena) begin
        next_count = count + 1;
        if (ena == 2'b11) begin
            next_count = count + 2;
        end
    end
end

endmodule

module functional_module (
    input [31:0] byte_reversed,
    input [15:0] up_count,
    output [31:0] final_output
);

assign final_output = {byte_reversed, up_count};

endmodule

module top_module (
    input clk,
    input reset,
    input ena,
    input [31:0] in,
    output [31:0] out
);

wire [31:0] byte_reversed;
wire [15:0] up_count;

byte_reversal byte_rev_inst (
    .in(in),
    .out(byte_reversed)
);

up_counter up_count_inst (
    .clk(clk),
    .reset(reset),
    .ena(ena),
    .count(up_count)
);

functional_module func_inst (
    .byte_reversed(byte_reversed),
    .up_count(up_count),
    .final_output(out)
);

endmodule