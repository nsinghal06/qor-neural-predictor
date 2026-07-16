//972
module multiplier_4bit (
    input [3:0] in_0,
    input [3:0] in_1,
    input clk,  // Add the clock input
    output reg [7:0] out
);

reg [3:0] stage_1_out;
reg [3:0] stage_2_out;
reg parity;

// Combinatorial logic to compute stage 1 output
always @(*) begin
    stage_1_out = in_0 * in_1;
end

// Register to hold stage 2 output
always @(posedge clk) begin
    stage_2_out <= stage_1_out;
end

// Register to hold the final output and compute parity
always @(posedge clk) begin
    out <= {stage_2_out, parity};
    parity <= out[7] ^ out[6] ^ out[5] ^ out[4] ^ out[3] ^ out[2] ^ out[1] ^ out[0];
end

endmodule