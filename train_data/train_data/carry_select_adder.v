module carry_select_adder(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire c,
    output wire [7:0] s
);

    wire [7:0] sum;
    wire [7:0] carry;

    assign {carry, sum} = a + b + c;
    assign s = (carry == 1'b0) ? sum : (a + b + 1'b1);

endmodule