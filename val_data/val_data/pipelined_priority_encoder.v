//1084
module pipelined_priority_encoder (
    input [7:0] in,
    input clk,
    output reg [2:0] pos
);

reg [7:0] in_reg;
reg [2:0] pos_reg;

always @(posedge clk) begin
    in_reg <= in;
end

always @(posedge clk) begin
    if (in_reg[7]) pos_reg <= 7;
    else if (in_reg[6]) pos_reg <= 6;
    else if (in_reg[5]) pos_reg <= 5;
    else if (in_reg[4]) pos_reg <= 4;
    else if (in_reg[3]) pos_reg <= 3;
    else if (in_reg[2]) pos_reg <= 2;
    else if (in_reg[1]) pos_reg <= 1;
    else if (in_reg[0]) pos_reg <= 0;
    else pos_reg <= pos_reg;
end

always @(*) begin
    if (in_reg[7]) pos <= 7;
    else if (in_reg[6]) pos <= 6;
    else if (in_reg[5]) pos <= 5;
    else if (in_reg[4]) pos <= 4;
    else if (in_reg[3]) pos <= 3;
    else if (in_reg[2]) pos <= 2;
    else if (in_reg[1]) pos <= 1;
    else if (in_reg[0]) pos <= 0;
    else pos <= pos_reg;
end

endmodule

module top_module (
    input [7:0] in,
    input clk,
    output [2:0] pos
);

pipelined_priority_encoder ppe (
    .in(in),
    .clk(clk),
    .pos(pos)
);

endmodule