module mux_module (
    input [3:0] a,
    input [3:0] b,
    input A,
    input B,
    output out
);
    wire [3:0] and_out;
    wire [3:0] decoder_out;
    
    and_module and_inst (
        .a(a),
        .b(b),
        .out(and_out)
    );
    
    decoder_module decoder_inst (
        .sel({A, B}),
        .out(decoder_out)
    );
    
    assign out = (decoder_out == 4'b1110) ? and_out[0] :
                  (decoder_out == 4'b1101) ? and_out[1] :
                  (decoder_out == 4'b1011) ? and_out[2] :
                  (decoder_out == 4'b0111) ? and_out[3] : 1'b0;
endmodule