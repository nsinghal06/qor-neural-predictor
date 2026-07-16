//280
module add_sub_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);

    wire [31:0] inverted_b;

    assign inverted_b = (sub == 1'b1) ? ~b : b;

    ripple_carry_adder adder(
        .a(a),
        .b(inverted_b),
        .carry_in(sub),
        .sum(sum),
        .carry_out()
    );

endmodule

module ripple_carry_adder(
    input [31:0] a,
    input [31:0] b,
    input carry_in,
    output [31:0] sum,
    output carry_out
);

    wire [32:0] carry;
    wire [31:0] sum_temp;

    assign sum_temp = a + b + carry_in;

    assign carry[32:0] = {sum_temp[30:0], sum_temp[31]} ^ {a[30:0], b[30:0], carry_in};

    assign sum = sum_temp;
    assign carry_out = carry[32];

endmodule