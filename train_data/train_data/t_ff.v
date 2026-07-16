module t_ff (
    input clk,
    input reset,
    input t,
    output q
);
    reg d;

    always @(posedge clk) begin
        if (reset) begin
            d <= 1'b0;
        end else begin
            d <= q ^ t;
        end
    end

    assign q = d;
endmodule