//1419
module even_parity #(
    parameter N = 4 // Assuming N is a parameter with a specific value
)(
    input clk,
    input rst,
    input [N-1:0] test_expr,
    input enable,
    output reg even_parity
);


reg [N-1:0] parity;
integer i;

always @(posedge clk) begin
    if (rst) begin
        parity <= 0;
        even_parity <= 0;
    end else if (enable) begin
        parity <= test_expr ^ parity;
        even_parity <= 1;
        for (i = 0; i < N; i = i + 1) begin
            if (parity[i]) begin
                even_parity <= ~even_parity;
            end
        end
    end
end

endmodule