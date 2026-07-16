//611
module ripple_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] carry;

    // First bit
    full_adder f1(
        .A(A[0]),
        .B(B[0]),
        .Cin(Cin),
        .Sum(Sum[0]),
        .Cout(carry[0])
    );

    // Second bit
    full_adder f2(
        .A(A[1]),
        .B(B[1]),
        .Cin(carry[0]),
        .Sum(Sum[1]),
        .Cout(carry[1])
    );

    // Third bit
    full_adder f3(
        .A(A[2]),
        .B(B[2]),
        .Cin(carry[1]),
        .Sum(Sum[2]),
        .Cout(carry[2])
    );

    // Fourth bit
    full_adder f4(
        .A(A[3]),
        .B(B[3]),
        .Cin(carry[2]),
        .Sum(Sum[3]),
        .Cout(Cout)
    );

endmodule

module full_adder(
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);

    wire s1, c1, s2;

    half_adder h1(
        .A(A),
        .B(B),
        .Sum(s1),
        .Cout(c1)
    );

    half_adder h2(
        .A(s1),
        .B(Cin),
        .Sum(s2),
        .Cout(Cout)
    );

    assign Sum = s2;

endmodule

module half_adder(
    input A,
    input B,
    output Sum,
    output Cout
);

    assign Sum = A ^ B;
    assign Cout = A & B;

endmodule