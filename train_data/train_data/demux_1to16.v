module demux_1to16(
    input [7:0] in,
    input [3:0] sel,
    output reg [15:0] out
);

    always @ (sel) begin
        case(sel)
            4'b0000: out[7:0] <= in;
            4'b0001: out[15:8] <= in;
            // add cases for 14 more outputs
            default: out <= 16'b0;
        endcase
    end

endmodule