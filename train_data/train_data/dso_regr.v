module dso_regr(addr, dout, 
    reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7);
    
    input [2:0] addr;
    output reg [7:0] dout;
    input [7:0] reg0;
    input [7:0] reg1;
    input [7:0] reg2;
    input [7:0] reg3;
    input [7:0] reg4;
    input [7:0] reg5;
    input [7:0] reg6;
    input [7:0] reg7;
    
    always @(*) begin
        case (addr)
        3'h0: dout <= reg0;
        3'h1: dout <= reg1;
        3'h2: dout <= reg2;
        3'h3: dout <= reg3;
        3'h4: dout <= reg4;
        3'h5: dout <= reg5;
        3'h6: dout <= reg6;
        3'h7: dout <= reg7;
        default: dout <= 8'b0;
        endcase
    end
endmodule