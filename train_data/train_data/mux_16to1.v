module mux_16to1(
    input [7:0] in_0,
    input [7:0] in_1,
    input [3:0] sel,
    output reg [7:0] out
);

    always @ (sel) begin
        case(sel)
            4'b0000: out <= in_0;
            4'b0001: out <= in_1;
            // add cases for 14 more inputs
            default: out <= 8'b0;
        endcase
    end

endmodule