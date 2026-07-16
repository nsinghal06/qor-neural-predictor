module that adds two 8-bit inputs
module adder_module (
    input [7:0] a,  // 8-bit input a
    input [7:0] b,  // 8-bit input b
    output reg [7:0] sum  // 8-bit output sum
);

    always @(*) begin
        sum = a + b;
    end

endmodule