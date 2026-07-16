module mux_256_to_1(
    input [1023:0] in,
    input [2:0] sel,
    output [3:0] out
);

    wire [7:0] mux_out [0:255];

    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : mux_block
            assign mux_out[i] = in[(i*4)+:4];
        end
    endgenerate

    assign out = mux_out[sel];

endmodule