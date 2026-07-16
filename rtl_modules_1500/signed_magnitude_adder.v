//433
module signed_magnitude_adder (
    input [3:0] A,
    input [3:0] B,
    input sign,
    output [3:0] sum
);

    wire [3:0] A_mag;
    wire [3:0] B_mag;
    wire carry_in;

    assign A_mag = (sign == 1) ? (~A + 1) : A;
    assign B_mag = (sign == 1) ? (~B + 1) : B;

    assign carry_in = (sign == 1) ? 1 : 0;

    wire carry_out0;
    full_adder fa0(A_mag[0], B_mag[0], carry_in, sum[0], carry_out0);
    wire carry_out1;
    full_adder fa1(A_mag[1], B_mag[1], carry_out0, sum[1], carry_out1);
    wire carry_out2;
    full_adder fa2(A_mag[2], B_mag[2], carry_out1, sum[2], carry_out2);
    full_adder fa3(A_mag[3], B_mag[3], carry_out2, sum[3]);

endmodule

module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign {cout, sum} = a + b + cin;

endmodule