//580
module half_adder (
    input a, b,
    output sum, carry_out
);

    assign sum = a ^ b;
    assign carry_out = a & b;

endmodule

module binary_counter (
    input clk, reset, enable,
    output [3:0] ones_digit,
    output [3:0] tens_digit,
    output [3:0] hundreds_digit,
    output [3:0] thousands_digit
);

    reg [3:0] ones_digit_reg, tens_digit_reg, hundreds_digit_reg, thousands_digit_reg;
    reg [15:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end else if (enable) begin
            count <= count + 1;
        end
    end

    always @(*) begin
        ones_digit_reg = count[3:0];
        tens_digit_reg = count[7:4];
        hundreds_digit_reg = count[11:8];
        thousands_digit_reg = count[15:12];
    end

    assign ones_digit = count[3:0];
    assign tens_digit = count[7:4];
    assign hundreds_digit = count[11:8];
    assign thousands_digit = count[15:12];

endmodule

module and_functional_module (
    input [15:0] sum_and_count_output,
    output [15:0] and_output
);

    assign and_output = (sum_and_count_output != 16'b0 && sum_and_count_output != 16'hFFFF) ? sum_and_count_output : 16'b0;

endmodule

module top_module (
    input a, b,
    input clk,
    input reset,
    input enable,
    output [15:0] q
);

    wire sum, carry_out;
    half_adder ha(.a(a), .b(b), .sum(sum), .carry_out(carry_out));

    wire [3:0] ones_digit, tens_digit, hundreds_digit, thousands_digit;
    binary_counter bc(.clk(clk), .reset(reset), .enable(enable), .ones_digit(ones_digit), .tens_digit(tens_digit), .hundreds_digit(hundreds_digit), .thousands_digit(thousands_digit));

    wire [15:0] sum_and_count_output;
    assign sum_and_count_output = {thousands_digit, hundreds_digit, tens_digit, ones_digit, sum, carry_out};

    and_functional_module and_fm(.sum_and_count_output(sum_and_count_output), .and_output(q));

endmodule