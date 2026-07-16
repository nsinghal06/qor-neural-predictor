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