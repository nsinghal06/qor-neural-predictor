//927
module edge_detector (
    input clk,
    input [7:0] in,
    output [7:0] out
);

reg [7:0] reg1, reg2, reg3;

always @(posedge clk) begin
    reg1 <= in;
end

always @(posedge clk) begin
    reg2 <= reg1;
end

always @(posedge clk) begin
    reg3 <= reg2;
end

assign out = (reg1 ^ reg2) | (reg2 ^ reg3);

endmodule

module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

wire [7:0] edge_detected;

edge_detector detector1(clk, in, edge_detected);
edge_detector detector2(clk, edge_detected, anyedge);

endmodule