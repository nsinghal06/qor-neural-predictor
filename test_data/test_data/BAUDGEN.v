module BAUDGEN #(
    parameter COUNTER = 25
) (
    input clk,
    input rst,
    output reg baud_edge
);
    reg [31:0] counter = 0;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            counter <= 0;
            baud_edge <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == COUNTER) begin
                baud_edge <= 1;
                counter <= 0;
            end else begin
                baud_edge <= 0;
            end
        end
    end
endmodule