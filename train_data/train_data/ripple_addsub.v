module ripple_addsub (
    input [3:0] A,
    input [3:0] B,
    input cin,
    input select,
    output [3:0] sum,
    output cout
);

    assign {cout, sum} = select ? (cin + A - B) : (cin + A + B);

endmodule