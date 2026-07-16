//535
module mux6to1_pipeline (
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    input clk,
    output reg [3:0] out
);

reg [3:0] and_out;
reg [3:0] stage1_out;
reg [2:0] stage2_out;

always @(*) begin
    case(sel)
        3'b000: stage1_out = data0;
        3'b001: stage1_out = data1;
        3'b010: stage1_out = data2;
        3'b011: stage1_out = data3;
        3'b100: stage1_out = data4;
        3'b101: stage1_out = data5;
        3'b110, 3'b111: stage1_out = {data0[1:0], data1[1:0], data2[1:0], data3[1:0], data4[1:0], data5[1:0]};
    endcase
end

always @(posedge clk) begin
    stage2_out <= stage1_out[2:0];
end

always @(posedge clk) begin
    and_out <= {stage2_out[1:0], stage2_out[2:1], stage2_out[2:0]} & 3'b11;
end

always @(posedge clk) begin
    if(sel == 3'b110 || sel == 3'b111) begin
        out <= and_out;
    end else begin
        out <= stage2_out;
    end
end

endmodule