module sum_module (
    input [3:0] gray_in,
    input [3:0] binary_in,
    output reg [7:0] sum_out
);

    always @(*) begin
        sum_out = {4'b0, binary_in} + {gray_in, 4'b0};
    end
endmodule