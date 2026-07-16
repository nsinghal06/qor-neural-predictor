//1111
module fifo_memory
#(parameter WIDTH_OUT = 8 , DEPTH= 256)
(
    output reg [WIDTH_OUT-1:0] dout,
    input clk,
    input tmp_ram_rd_en ,
    input  WEA,
    input  srst,
    input [9:0]Q,
    input [WIDTH_OUT-1:0] din,
    input E
);
reg [WIDTH_OUT-1:0] mem [0:DEPTH-1];
always @(posedge clk or posedge srst) begin
    if (srst) begin // flip flop reset should be synchronous for negedge triggered memory
        dout <= 0;
    end
    else if (tmp_ram_rd_en & ~WEA) begin
        dout <= mem[Q];
    end
end

always @(posedge clk ) begin
    if (!srst) begin
        mem[Q] <= din;
    end
end

endmodule