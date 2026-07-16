//1431
module top_ALU(
    input [31:0] a,    // First input
    input [31:0] b,    // Second input
    input [2:0] select,    // 3-bit select input for operation type
    input enable,    // Input to enable or disable the output
    output [31:0] out    // 32-bit output
);
    wire [15:0] a_low, b_low, out_low;
    wire [15:0] a_high, b_high, out_high;

    // Split the inputs into two 16-bit parts
    assign a_low = a[15:0];
    assign b_low = b[15:0];
    assign a_high = a[31:16];
    assign b_high = b[31:16];

    // Create two adder-subtractor modules for the two 16-bit parts
    adder_subtractor addsub_low(
        .a(a_low),
        .b(b_low),
        .select(select[0]),
        .out(out_low)
    );

    adder_subtractor addsub_high(
        .a(a_high),
        .b(b_high),
        .select(select[0]),
        .out(out_high)
    );

    // Combine the two 16-bit results into a 32-bit result
    assign out = {out_high, out_low};

endmodule

module adder_subtractor(
    input [15:0] a,    // First input
    input [15:0] b,    // Second input
    input select,    // Select input for add or subtract
    output [15:0] out    // Output
);

    assign out = select ? a - b : a + b;

endmodule