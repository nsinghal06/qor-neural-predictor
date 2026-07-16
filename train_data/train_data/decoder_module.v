module decoder_module (
    input [1:0] sel,
    output [3:0] out
);
    assign out = (sel == 2'b00) ? 4'b1110 :
                  (sel == 2'b01) ? 4'b1101 :
                  (sel == 2'b10) ? 4'b1011 :
                  (sel == 2'b11) ? 4'b0111 : 4'b0000;
endmodule