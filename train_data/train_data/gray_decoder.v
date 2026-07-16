//390
module gray_decoder (
    input [7:0] gray_in,
    output [3:0] decoded_out
);

    assign decoded_out[0] = ~(gray_in[0] ^ gray_in[1] ^ gray_in[3]);
    assign decoded_out[1] = ~(gray_in[0] ^ gray_in[2] ^ gray_in[3]);
    assign decoded_out[2] = ~(gray_in[1] ^ gray_in[2] ^ gray_in[3]);
    assign decoded_out[3] = ~(gray_in[0] ^ gray_in[1] ^ gray_in[2]);

endmodule

module gray_decoder_top (
    input [7:0] gray_in,
    output [15:0] decoded_gray_sum
);

    wire [3:0] decoded_out;
    wire [11:0] sum_out;

    gray_decoder decoder(gray_in, decoded_out);

    assign sum_out = {4'b0000, decoded_out} + gray_in;

    assign decoded_gray_sum = {sum_out[11:8], sum_out[7:0]};

endmodule