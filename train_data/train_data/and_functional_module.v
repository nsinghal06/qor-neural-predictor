module and_functional_module (
    input [15:0] sum_and_count_output,
    output [15:0] and_output
);

    assign and_output = (sum_and_count_output != 16'b0 && sum_and_count_output != 16'hFFFF) ? sum_and_count_output : 16'b0;

endmodule