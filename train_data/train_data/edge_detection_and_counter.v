module edge_detection_and_counter (
    input clk,
    input reset,      // Synchronous active-high reset
    input [7:0] in,   // Input vector
    output reg [3:0] counter_out   // Output 4-bit LED counter
);
    wire [7:0] swapped_in;
    wire edge_detected;

    byte_swapping bs (
        .in(in),
        .out(swapped_in)
    );

    edge_detection ed (
        .clk(clk),
        .reset(reset),
        .in(swapped_in[0]),
        .out(edge_detected)
    );

    always @(posedge clk) begin
        if (reset) begin
            counter_out <= 4'b0;
        end else begin
            if (edge_detected) begin
                if (counter_out == 4'b1111) begin
                    counter_out <= 4'b0;
                end else begin
                    counter_out <= counter_out + 1;
                end
            end
        end
    end
endmodule