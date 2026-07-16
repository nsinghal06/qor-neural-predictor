//1428
module four_bit_multiplier (
    input signed [3:0] A,
    input signed [3:0] B,
    output [7:0] result
);

    assign result = A * B;

endmodule

module three_to_eight_decoder (
    input in,
    output reg [2:0] out
);

    always @(*) begin
        case(in)
            1'b0: out = 3'b000;
            1'b1: out = 3'b111;
        endcase
    end

endmodule

module calculator (
    input signed [3:0] A,
    input signed [3:0] B,
    output [7:0] LEDS
);

    wire signed [7:0] mult_result;
    wire [2:0] decoder_out;
    wire signed [7:0] sum_result;

    four_bit_multiplier mult_module (
        .A(A),
        .B(B),
        .result(mult_result)
    );

    three_to_eight_decoder decoder_module (
        .in(mult_result[7]),
        .out(decoder_out)
    );

    assign LEDS = ~{decoder_out, 3'b000};

    assign sum_result = mult_result + {8'b00000000, decoder_out};

endmodule