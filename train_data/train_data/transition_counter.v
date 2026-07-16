//1108
module transition_counter (
    input clk,
    input reset,
    input [31:0] in,
    output reg [3:0] count
);

reg [31:0] prev_in;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
        prev_in <= 32'b0;
    end else begin
        if (in[0] && !prev_in[0]) begin
            count <= count + 1;
        end
        prev_in <= in;
    end
end

endmodule

module and_gate (
    input [3:0] count_in,
    input [31:0] in,
    output reg final_output
);

always @(*) begin
    if (count_in == 4'b0) begin
        final_output <= 1'b0;
    end else begin
        final_output <= (in & (count_in << 28)) == (count_in << 28);
    end
end

endmodule

module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [3:0] count_out,
    output final_output
);

wire [3:0] count;
wire and_out;

transition_counter tc (
    .clk(clk),
    .reset(reset),
    .in(in),
    .count(count)
);

and_gate ag (
    .count_in(count),
    .in(in),
    .final_output(and_out)
);

assign count_out = count;
assign final_output = and_out;

endmodule