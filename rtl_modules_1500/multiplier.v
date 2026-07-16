//1343
module multiplier (
    input [7:0] a,
    input [7:0] b,
    output [15:0] product
);
    assign product = a * b;
endmodule

module comparator (
    input [7:0] a,
    input [7:0] b,
    output greater
);
    assign greater = (a > b) ? 1 : 0;
endmodule

module functional_module (
    input [7:0] a,
    input [7:0] b,
    output [15:0] result
);
    wire [15:0] product;
    wire greater;

    multiplier m(a, b, product);
    comparator c(a, b, greater);

    assign result = (greater == 1) ? product : (product / b);
endmodule

module top_module (
    input [7:0] a,
    input [7:0] b,
    output [15:0] result
);
    functional_module f(a, b, result);
endmodule