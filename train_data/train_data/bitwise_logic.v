//111
module bitwise_logic(
    input [99:0] in1,
    input [1:0] in2,
    output [99:0] out_and,
    output [99:0] out_or,
    output [99:0] out_xor
);

    assign out_and = in1 & {100{in2[0]}};
    assign out_or = in1 | {100{in2[0]}};
    assign out_xor = in1 ^ {100{in2[0]}};

endmodule

module threshold_module(
    input [99:0] in_and,
    input [99:0] in_or,
    input [99:0] in_xor,
    input threshold,
    output [99:0] final_out
);

    assign final_out = ((in_or & threshold) | (in_xor & ~threshold)) ^ (in_and & ~threshold) ;

endmodule

module top_module(
    input a,
    input b,
    input sel,
    input [99:0] in1,
    input [99:0] in2,
    input threshold,
    output out_always,
    output [99:0] out_and,
    output [99:0] out_or,
    output [99:0] out_xor,
    output [99:0] final_out
);

    wire [99:0] selected_input = sel ? in2 : in1;
    wire [99:0] and_out, or_out, xor_out;
    wire [99:0] and_or_xor;

    bitwise_logic bitwise_inst(
        .in1(selected_input),
        .in2({a, b}),
        .out_and(and_out),
        .out_or(or_out),
        .out_xor(xor_out)
    );

    threshold_module threshold_inst(
        .in_and(and_out),
        .in_or(or_out),
        .in_xor(xor_out),
        .threshold(threshold),
        .final_out(final_out)
    );

    assign out_always = 1'b1;
    assign out_and = and_out;
    assign out_or = or_out;
    assign out_xor = xor_out;

endmodule