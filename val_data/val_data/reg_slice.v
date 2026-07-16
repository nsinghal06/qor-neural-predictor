module reg_slice (
    input clk,
    input reset,
    input [3:0] in,
    output reg [3:0] out
);

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            out <= 0;
        end else begin
            out <= in;
        end
    end

endmodule