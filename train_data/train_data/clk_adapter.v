//1305
module clk_adapter (
    input clk_in,
    output reg clk_out, // Output clock signal
    input reset,
    output reg reset_sync // Synchronous reset signal
);

parameter DELAY_CYCLES = 2; // Number of cycles to delay reset_sync by

reg [DELAY_CYCLES-1:0] reset_sync_delayed;

// Generate synchronous reset signal
always @(posedge clk_out) begin
    if (reset) begin
        reset_sync <= 1'b1;
    end else if (reset_sync_delayed == 0) begin
        reset_sync <= 1'b0;
    end
end

// Delay reset_sync signal by DELAY_CYCLES cycles
always @(posedge clk_out) begin
    if (reset) begin
        reset_sync_delayed <= 0;
    end else if (reset_sync_delayed == 0) begin
        reset_sync_delayed <= DELAY_CYCLES-1;
    end else begin
        reset_sync_delayed <= reset_sync_delayed - 1;
    end
end

// Generate output clock signal
always @(posedge clk_in) begin
    clk_out <= ~clk_out;
end

endmodule