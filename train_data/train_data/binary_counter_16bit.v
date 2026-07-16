module binary_counter_16bit (
    input clk,
    input reset,
    output reg [15:0] q);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'd0;
        end else begin
            q <= q + 1;
        end
    end

endmodule