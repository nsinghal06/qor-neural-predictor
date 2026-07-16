module left_shifter(
    input [7:0] in,    // 8-bit input
    output reg [7:0] out    // 8-bit output
);

    always @(*) begin
        out = in << 1;    // shift the input left by 1 bit
    end

endmodule