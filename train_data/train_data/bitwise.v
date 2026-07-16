module bitwise (
    input [3:0] A,
    input [3:0] B,
    input [2:0] OP,
    output [3:0] Y
);

    assign Y = (OP == 3'b010) ? A & B :
               (OP == 3'b011) ? A | B :
               (OP == 3'b100) ? A ^ B :
               4'b0;

endmodule