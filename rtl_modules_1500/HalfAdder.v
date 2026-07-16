//583
module HalfAdder(Sum, Carry, A, B);
    output Sum, Carry;
    input A, B;

    assign Sum = A ^ B;
    assign Carry = A & B;
endmodule

module FullAdder(Sum, Carry, A, B, Cin);
    output Sum, Carry;
    input A, B, Cin;

    wire s1, c1;

    HalfAdder HA1(s1, c1, A, B);
    HalfAdder HA2(Sum, Carry, s1, Cin);
endmodule

module Adder4(Sum, Cout, A, B, Cin);
    output [3:0] Sum;
    output Cout;
    input [3:0] A, B;
    input Cin;
    
    wire [3:0] Carry;
    
    // First stage: half adder
    HalfAdder HA1(Sum[0], Carry[0], A[0], B[0]);
    
    // Second stage: full adder
    FullAdder FA1(Sum[1], Carry[1], A[1], B[1], Carry[0]);
    
    // Third stage: full adder
    FullAdder FA2(Sum[2], Carry[2], A[2], B[2], Carry[1]);
    
    // Fourth stage: full adder
    FullAdder FA3(Sum[3], Carry[3], A[3], B[3], Carry[2]);
    
    // Output carry
    assign Cout = Carry[3];
endmodule