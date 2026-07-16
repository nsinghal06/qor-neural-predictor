module clk_divider_cell(input clk, input [3:0] div_ratio, output reg clk_out);
    reg [3:0] counter;

    always @(posedge clk) begin
        if (counter == div_ratio - 1) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule