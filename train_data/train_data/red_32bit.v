module red_32bit (
    input clk,
    input reset, // Synchronous active-high reset
    input [31:0] in,
    output [31:0] out
);
    reg [31:0] in_delayed;

    always @ (posedge clk) begin
        if (reset) begin
            in_delayed <= 0;
        end else begin
            in_delayed <= in;
        end
    end

    assign out = in & ~in_delayed;
endmodule