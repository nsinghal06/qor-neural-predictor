//959
module booth_multiplier (
    input clk,
    input reset,
    input [3:0] A,
    input [3:0] B,
    output [7:0] result
);

reg [3:0] multiplicand_reg;
reg [2:0] multiplier_reg;
reg [7:0] product_reg;

wire [3:0] A_neg;
wire [3:0] B_neg;
wire [7:0] product_neg;
wire [7:0] addend;

assign A_neg = (~A) + 1;
assign B_neg = (~B) + 1;
assign product_neg = (~product_reg) + 1;
assign addend = (multiplier_reg[1:0] == 2'b01) ? multiplicand_reg : 
                  (multiplier_reg[1:0] == 2'b10) ? A_neg : 
                  (multiplier_reg[1:0] == 2'b11) ? B_neg : 
                  0;

always @(posedge clk) begin
    if (reset) begin
        multiplicand_reg <= 4'b0;
        multiplier_reg <= 3'b0;
        product_reg <= 8'b0;
    end else begin
        multiplicand_reg <= A;
        multiplier_reg <= {B, 1'b0};
        product_reg <= product_reg + addend;
    end
end

assign result = (product_reg[7] == 1) ? product_neg : product_reg;

endmodule