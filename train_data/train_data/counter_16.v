module counter_16 (
    input clk,
    input reset, // Synchronous active-high reset
    output reg [15:0] out // 16-bit counter output
);
    always @ (posedge clk) begin
        if (reset) begin
            out <= 16'b0;
        end else begin
            out <= out + 1;
        end
    end
endmodule