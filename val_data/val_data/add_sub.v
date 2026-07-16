module add_sub (
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] out
);
    
    assign out = sub ? a - b : a + b;
    
endmodule