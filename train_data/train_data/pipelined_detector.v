//181
module pipelined_detector (
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] in_reg1, in_reg2, in_reg3, in_reg4;
reg [31:0] out_reg1, out_reg2, out_reg3, out_reg4;

always @(posedge clk) begin
    if (reset) begin
        in_reg1 <= 0;
        in_reg2 <= 0;
        in_reg3 <= 0;
        in_reg4 <= 0;
        out_reg1 <= 0;
        out_reg2 <= 0;
        out_reg3 <= 0;
        out_reg4 <= 0;
    end else begin
        in_reg1 <= in;
        in_reg2 <= in_reg1;
        in_reg3 <= in_reg2;
        in_reg4 <= in_reg3;
        
        out_reg1 <= out;
        out_reg2 <= out_reg1;
        out_reg3 <= out_reg2;
        out_reg4 <= out_reg3;
        
        out[31:0] <= (in_reg1[31] && !in_reg2[31] && !in_reg3[31] && !in_reg4[31]) ? 32'hFFFFFFFF : 0;
        out[30:0] <= (in_reg1[30:0] && !in_reg2[30:0] && !in_reg3[30:0] && !in_reg4[30:0]) ? {31'h0, 1'h1} : {31'h0, 1'h0};
    end
end

endmodule

module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

pipelined_detector detector (
    .clk(clk),
    .reset(reset),
    .in(in),
    .out(out)
);

endmodule