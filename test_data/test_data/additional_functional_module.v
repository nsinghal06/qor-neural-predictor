module additional_functional_module (
    input [2:0] priority_encoder_out,
    input [15:0] sum_and_compare_sum,
    output [15:0] final_output
);
    
    assign final_output = sum_and_compare_sum + ((priority_encoder_out % 2 == 0) ? -1 : 1);
    
endmodule