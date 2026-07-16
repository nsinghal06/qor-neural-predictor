//45
module gated_clk (
    input  CLK ,
    input  GATE,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB,
    output GCLK
);

    reg gated_clk;

    always @(posedge CLK) begin
        if (GATE) begin
            gated_clk <= 1'b1;
        end else begin
            gated_clk <= 1'b0;
        end
    end

    assign GCLK = gated_clk;

endmodule