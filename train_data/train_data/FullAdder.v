module FullAdder(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);

    // Sum is the XOR of the three inputs
    assign S = A ^ B ^ Cin;

    // Carry-out is the majority function of the three inputs (AB + BCin + ACin)
    assign Cout = (A & B) | (B & Cin) | (A & Cin);

endmodule