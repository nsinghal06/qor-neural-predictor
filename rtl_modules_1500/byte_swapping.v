//822
module byte_swapping (
    input [7:0] in,
    output reg [7:0] out
);
    always @(*) begin
        out[7:0] = {in[7], in[6], in[5], in[4], in[3], in[2], in[1], in[0]};
    end
endmodule

module edge_detection (
    input clk,
    input reset,      // Synchronous active-high reset
    input in,         // Input signal
    output reg out    // Output edge detection signal
);
    reg in_prev;

    always @(posedge clk) begin
        if (reset) begin
            in_prev <= 1'b0;
            out <= 1'b0;
        end else begin
            in_prev <= in;
            out <= (in & ~in_prev);
        end
    end
endmodule

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