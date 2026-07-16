//464
module tribuff(
    input din_0,
    input din_1,
    input din_2,
    input en,
    output dout
);

    assign dout = en ? {din_2, din_1, din_0} : 0;

endmodule