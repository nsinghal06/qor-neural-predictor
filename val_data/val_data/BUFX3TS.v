module BUFX3TS (A, OE, Y);
    input A, OE;
    output Y;

    assign Y = OE ? A : 1'b0;
endmodule