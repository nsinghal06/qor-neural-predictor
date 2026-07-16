//1190
module pipelined_and_gate(
    input a,
    input b,
    input clk,
    output reg out
);

    reg stage1_out;
    reg stage2_out;

    always @(posedge clk) begin
        stage1_out <= ~(a ^ b);
    end

    always @(posedge clk) begin
        stage2_out <= ~(stage1_out ^ stage2_out);
    end

    always @(posedge clk) begin
        out <= stage2_out;
    end

endmodule