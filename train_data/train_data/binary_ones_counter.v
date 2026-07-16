module binary_ones_counter #(
    parameter N = 4 // Number of bits for the binary ones counter
) (
    input [N-1:0] data_in, // Input signal
    output [N-1:0] ones_count_raw // Output signal
);

    assign ones_count_raw = {N{1'b0}} + data_in;

endmodule