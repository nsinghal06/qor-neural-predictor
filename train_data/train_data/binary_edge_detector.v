//867
module binary_edge_detector (
    input clk,
    input rst_n,
    input bin_in,
    output reg rise_edge,
    output reg fall_edge
);

reg prev_bin_in;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_bin_in <= 1'b0;
    end else begin
        rise_edge <= (bin_in && !prev_bin_in);
        fall_edge <= (!bin_in && prev_bin_in);
        prev_bin_in <= bin_in;
    end
end

endmodule

module priority_encoder (
    input [3:0] in,
    output [1:0] out
);

assign out = (in[3]) ? 2'b11 :
             (in[2]) ? 2'b10 :
             (in[1]) ? 2'b01 :
             (in[0]) ? 2'b00 : 2'b00;

endmodule

module final_output (
    input rise_edge,
    input fall_edge,
    input [1:0] priority_encoder,
    output reg [1:0] out
);

always @(*) begin
    if (rise_edge) begin
        out = priority_encoder;
    end else if (fall_edge) begin
        out = ~priority_encoder;
    end else begin
        out = 2'b00;
    end
end

endmodule

module top_module (
    input clk,
    input rst_n,
    input [3:0] in,
    output [3:0] edge_detect,
    output [1:0] priority_encoder,
    output [1:0] final_output
);

binary_edge_detector edge_detector_0 (
    .clk(clk),
    .rst_n(rst_n),
    .bin_in(in[3]),
    .rise_edge(edge_detect[3]),
    .fall_edge(edge_detect[2])
);

binary_edge_detector edge_detector_1 (
    .clk(clk),
    .rst_n(rst_n),
    .bin_in(in[2]),
    .rise_edge(edge_detect[1]),
    .fall_edge(edge_detect[0])
);

priority_encoder encoder (
    .in(in),
    .out(priority_encoder)
);

final_output final_out (
    .rise_edge(edge_detect[3]),
    .fall_edge(edge_detect[2]),
    .priority_encoder(priority_encoder),
    .out(final_output)
);

endmodule