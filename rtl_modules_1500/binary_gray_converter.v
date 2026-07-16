//638
module binary_gray_converter (
    input [3:0] binary_in,
    output reg [3:0] gray_out
);

    always @(*) begin
        gray_out[3] = binary_in[3];
        gray_out[2] = binary_in[2] ^ gray_out[3];
        gray_out[1] = binary_in[1] ^ gray_out[2];
        gray_out[0] = binary_in[0] ^ gray_out[1];
    end
endmodule

module gray_binary_converter (
    input [3:0] gray_in,
    output reg [3:0] binary_out
);

    always @(*) begin
        binary_out[3] = gray_in[3];
        binary_out[2] = gray_in[3] ^ gray_in[2];
        binary_out[1] = gray_in[2] ^ gray_in[1];
        binary_out[0] = gray_in[1] ^ gray_in[0];
    end
endmodule

module sum_module (
    input [3:0] gray_in,
    input [3:0] binary_in,
    output reg [7:0] sum_out
);

    always @(*) begin
        sum_out = {4'b0, binary_in} + {gray_in, 4'b0};
    end
endmodule

module top_module (
    input clk,
    input reset,
    input [3:0] binary_in,
    output [3:0] gray_out,
    input [3:0] gray_in,
    output [3:0] binary_out,
    output [7:0] sum_out
);

    binary_gray_converter bin2gray(.binary_in(binary_in), .gray_out(gray_out));
    gray_binary_converter gray2bin(.gray_in(gray_in), .binary_out(binary_out));
    sum_module sum(.gray_in(gray_out), .binary_in(binary_out), .sum_out(sum_out));

endmodule