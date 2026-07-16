module reg_module (
    input clk,
    input reset,  // Synchronous active-high reset
    input [7:0] d,  // 8-bit input
    output reg [7:0] q  // 8-bit output
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'h34;
        end else begin
            q <= d;
        end
    end

endmodule