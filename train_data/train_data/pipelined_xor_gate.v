//1208
module pipelined_xor_gate(
    input a,
    input b,
    input clk,
    output reg out
);

reg a_reg, b_reg;

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
    out <= a_reg ^ b_reg;
end

endmodule