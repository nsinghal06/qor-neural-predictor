//254
module add_sub_32bit(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);

wire [31:0] a_inv;
wire [31:0] b_inv;
wire carry_in;
wire carry_out;
wire [31:0] sum_temp;

assign carry_in = sub;

ripple_carry_adder adder(
    .a(a),
    .b(b_inv),
    .carry_in(carry_in),
    .carry_out(carry_out),
    .sum(sum_temp)
);

assign sum = sub ? ~sum_temp + 1 : sum_temp;

assign a_inv = ~a;
assign b_inv = ~b;

endmodule

module ripple_carry_adder(
    input [31:0] a,
    input [31:0] b,
    input carry_in,
    output carry_out,
    output [31:0] sum
);

wire [31:0] carry;

genvar i;

generate
    for (i = 0; i < 31; i = i + 1) begin : adder_loop
        full_adder adder(
            .a(a[i]),
            .b(b[i]),
            .carry_in(carry[i]),
            .carry_out(carry[i+1]),
            .sum(sum[i])
        );
    end
endgenerate

assign carry_out = carry[31];
assign carry[0] = carry_in;
assign sum[31] = carry[31];

endmodule

module full_adder(
    input a,
    input b,
    input carry_in,
    output carry_out,
    output sum
);

assign {carry_out, sum} = {carry_in, a} + {carry_in, b} + {carry_in, carry_in};

endmodule