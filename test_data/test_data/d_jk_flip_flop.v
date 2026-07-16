module d_jk_flip_flop(
    input clk,
    input d,
    input j,
    input k,
    input select,
    output reg q
);

wire d_sel, jk_sel;

flip_flop_selector selector(
    .select(select),
    .d_sel(d_sel),
    .jk_sel(jk_sel)
);

always @(posedge clk) begin
    if (d_sel) begin
        q <= d;
    end else begin
        if (jk_sel) begin
            q <= j ? ~q : q;
        end else begin
            q <= k ? q : ~q;
        end
    end
end

endmodule