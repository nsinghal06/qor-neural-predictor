//1465
module priority_encoder (
    input [7:0] in,
    output [2:0] pos
);

wire [2:0] gray_code;

// Binary-to-gray code conversion
assign gray_code = in ^ (in >> 1);

// Gray-to-binary code conversion using a 1-hot decoder
wire [7:0] binary_code;
decoder_3to8 decoder (
    .in(gray_code),
    .out(binary_code)
);

// Binary-to-decimal code conversion
assign pos = binary_code[2:0];

endmodule

module decoder_3to8 (
    input [2:0] in,
    output reg [7:0] out
);

always @(*) begin
    case (in)
        3'b000: out = 8'b00000001;
        3'b001: out = 8'b00000010;
        3'b010: out = 8'b00000100;
        3'b011: out = 8'b00001000;
        3'b100: out = 8'b00010000;
        3'b101: out = 8'b00100000;
        3'b110: out = 8'b01000000;
        3'b111: out = 8'b10000000;
    endcase
end

endmodule