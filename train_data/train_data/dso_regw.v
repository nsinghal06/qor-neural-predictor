module dso_regw(nrst, clk, addr, din, we, sel,
    reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7);
    
    input nrst;
    input clk;
    input [2:0] addr;
    input [7:0] din;
    input we;
    output [7:0] sel;
    output [7:0] reg0;
    output [7:0] reg1;
    output [7:0] reg2;
    output [7:0] reg3;
    output [7:0] reg4;
    output [7:0] reg5;
    output [7:0] reg6;
    output [7:0] reg7;
    wire [7:0] addr_dec;
    
    decode38 dec(.en(we), .din(addr), .dout(addr_dec));
    assign sel = addr_dec;
    
    regxb #(8) r0(.nrst(nrst), .clk(clk), .en(addr_dec[0]), .din(din), .regout(reg0));
    regxb #(8) r1(.nrst(nrst), .clk(clk), .en(addr_dec[1]), .din(din), .regout(reg1));
    regxb #(8) r2(.nrst(nrst), .clk(clk), .en(addr_dec[2]), .din(din), .regout(reg2));
    regxb #(8) r3(.nrst(nrst), .clk(clk), .en(addr_dec[3]), .din(din), .regout(reg3));
    regxb #(8) r4(.nrst(nrst), .clk(clk), .en(addr_dec[4]), .din(din), .regout(reg4));
    regxb #(8) r5(.nrst(nrst), .clk(clk), .en(addr_dec[5]), .din(din), .regout(reg5));
    regxb #(8) r6(.nrst(nrst), .clk(clk), .en(addr_dec[6]), .din(din), .regout(reg6));
    regxb #(8) r7(.nrst(nrst), .clk(clk), .en(addr_dec[7]), .din(din), .regout(reg7));
endmodule