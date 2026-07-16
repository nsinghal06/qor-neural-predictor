//1174
module memory_arbiter(
    input clk,
    input rst,
    input [31:0] sram_din,
    input [31:0] mdin,
    input [31:0] wdin,
    input sram_re,
    input mwe,
    input mreq,
    input wwe,
    input wreq,
    input [SSRAM_HADR:0] sram_adr,
    input [SSRAM_HADR:0] madr,
    input [SSRAM_HADR:0] wadr,
    output [31:0] sram_dout,
    output sram_we,
    output mdout,
    output [31:0] wdout,
    output wack
);

parameter SSRAM_HADR = 14;

reg [SSRAM_HADR:0] sram_adr_reg;
reg [31:0] sram_dout_reg;
reg sram_we_reg;
reg mack_reg;
reg mcyc_reg;
reg wack_r_reg;

wire wsel = (wreq | wack) & !mreq;

always @(posedge clk or negedge rst)
    if (!rst) begin
        sram_adr_reg <= 0;
        sram_dout_reg <= 0;
        sram_we_reg <= 0;
        mack_reg <= 0;
        mcyc_reg <= 0;
        wack_r_reg <= 0;
    end
    else begin
        if (wsel) sram_dout_reg <= wdin;
        else sram_dout_reg <= mdin;

        if (wsel) sram_adr_reg <= wadr;
        else sram_adr_reg <= madr;

        if (wsel) sram_we_reg <= wreq & wwe;
        else sram_we_reg <= mwe & mcyc_reg;

        mack_reg <= mreq;
        mcyc_reg <= mack_reg;
        
        wack_r_reg <= wreq & !mreq & !wack;
    end

assign sram_dout = sram_dout_reg;
assign sram_adr = sram_adr_reg;
assign sram_we = sram_we_reg;
assign sram_re = 1'b1;

assign mdout = sram_din;

assign wdout = sram_din;
assign wack = wack_r_reg & !mreq;

endmodule