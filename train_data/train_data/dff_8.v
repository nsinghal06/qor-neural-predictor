module dff_8 (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk, negedge reset) begin
    if (reset == 1'b0) begin
        q <= 8'b00000000;
    end else begin
        q <= d;
    end
end

endmodule