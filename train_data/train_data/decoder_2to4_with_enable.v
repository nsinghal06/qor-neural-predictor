module decoder_2to4_with_enable(
    input in,
    input [3:0] sel,
    output reg [3:0] out
);

always @ (in or sel) begin
    if (in == 1'b0) begin
        case (sel)
            4'b0000: out = 4'b0001;
            4'b0001: out = 4'b0010;
            4'b0010: out = 4'b0100;
            4'b0011: out = 4'b1000;
            default: out = 4'b0000;
        endcase
    end else begin
        out = 4'b0000;
    end
end

endmodule