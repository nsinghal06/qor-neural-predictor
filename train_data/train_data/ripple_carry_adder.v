//1380
module ripple_carry_adder(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum,
    output [32:0] carry // range increased by 1
);
    assign carry[0] = 1'b0; // least significant carry bit is initialized to 0
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin: adder
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .c(carry[i]), // carry-in from the previous stage
                .sum(sum[i]),
                .carry(carry[i+1]) // carry-out to the next stage
            );
        end
    endgenerate
endmodule

module full_adder(
    input a,
    input b,
    input c,
    output sum,
    output carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (b & c) | (a & c);
endmodule