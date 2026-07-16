//667
module flip_flop_selector(
    input select,
    output reg d_sel,
    output reg jk_sel
);

always @(*) begin
    d_sel = ~select;
    jk_sel = select;
end

endmodule

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

module top_module(
    input clk,
    input d,
    input j,
    input k,
    input select,
    output reg q
);

d_jk_flip_flop flip_flop(
    .clk(clk),
    .d(d),
    .j(j),
    .k(k),
    .select(select),
    .q(q)
);

endmodule