module sum_and_compare (
    input [31:0] in_word,
    input [15:0] threshold,
    output [15:0] sum,
    output greater_than_threshold
);
    
    assign sum = in_word[31:16] + in_word[15:0];
    assign greater_than_threshold = (sum > threshold);
    
endmodule