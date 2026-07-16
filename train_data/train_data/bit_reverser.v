//1095
module bit_reverser (
    input clk,
    input [7:0] D,
    output reg [7:0] R
);

reg [7:0] shift_reg;

always @ (posedge clk) begin
    shift_reg <= {shift_reg[6:0], D[0]};
end

always @ (posedge clk) begin
    R <= {shift_reg[7], shift_reg[6], shift_reg[5], shift_reg[4], shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]};
end

endmodule