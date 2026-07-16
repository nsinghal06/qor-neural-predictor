//828
module half_word_splitter (
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);
    assign out_hi = in[15:8];
    assign out_lo = in[7:0];
endmodule

module edge_detector (
    input wire clk,
    input wire [7:0] in,
    output reg [7:0] out
);
    always @(posedge clk) begin
        out = in ^ (in >> 1);
    end
endmodule

module functional_module (
    input wire [7:0] in1,
    input wire [7:0] in2,
    output wire [7:0] sum
);
    assign sum = in1 + in2;
endmodule

module top_module (
    input wire [15:0] in,
    input wire [7:0] select,
    input wire clk,
    input wire [7:0] in_edge, // NOTE: updated input port name from 'edge' to 'in_edge'
    output reg [7:0] out_hi,
    output reg [7:0] out_lo,
    output reg [7:0] anyedge_sum,
    input wire rst
);
    wire [7:0] edge_out;
    wire [7:0] splitter_out_hi;
    wire [7:0] splitter_out_lo;
    wire [7:0] functional_out;

    half_word_splitter splitter(
        .in(in),
        .out_hi(splitter_out_hi),
        .out_lo(splitter_out_lo)
    );

    edge_detector edge(
        .clk(clk),
        .in(in_edge),
        .out(edge_out)
    );

    functional_module functional(
        .in1(splitter_out_hi),
        .in2(edge_out),
        .sum(functional_out)
    );

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            out_hi <= 0;
            out_lo <= 0;
            anyedge_sum <= 0;
        end else begin
            if (select == 1) begin
                out_hi <= splitter_out_hi;
                out_lo <= splitter_out_lo;
                anyedge_sum <= 0;
            end else begin
                out_hi <= 0;
                out_lo <= 0;
                anyedge_sum <= functional_out;
            end
        end
    end
endmodule