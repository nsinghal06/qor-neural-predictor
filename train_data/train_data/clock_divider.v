//933
module clock_divider(
    input clk,
    input RST,
    output dclk
);

    // Define the maximum counter value
    parameter [15:0] CNTENDVAL = 16'b1011011100110101;

    // Define the counter register
    reg [15:0] cntval;

    // Define the flip-flop to toggle the output clock
    reg dclk_ff;

    // Increment the counter on the rising edge of the input clock
    always @(posedge clk) begin
        if (RST) begin
            // Reset the counter to 0 if the reset signal is high
            cntval <= 0;
        end else begin
            // Increment the counter by 1
            cntval <= cntval + 1;
        end
    end

    // Toggle the output clock when the counter reaches its maximum value
    always @(posedge clk) begin
        if (cntval == CNTENDVAL) begin
            dclk_ff <= ~dclk_ff;
        end
    end

    // Assign the output clock to the flip-flop output
    assign dclk = dclk_ff;

endmodule