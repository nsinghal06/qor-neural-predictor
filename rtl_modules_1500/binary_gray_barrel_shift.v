//875
module binary_gray_barrel_shift (
    input [3:0] B, // 4-bit binary input
    input [3:0] S, // 4-bit shift amount input
    output [3:0] G // 4-bit gray code output
);

    wire [3:0] shifted_input;
    wire [3:0] gray_code_output;

    binary_to_gray_converter converter(
        .B(shifted_input),
        .G(gray_code_output)
    );

    barrel_shifter shifter(
        .A(B),
        .S(S),
        .Y(shifted_input)
    );

    xor_gate xor_inst(
        .A(gray_code_output),
        .B(shifted_input),
        .G(G)
    );

endmodule

module binary_to_gray_converter (
    input [3:0] B, // 4-bit binary input
    output [3:0] G // 4-bit gray code output
);

    assign G[0] = B[0];
    assign G[1] = B[0] ^ B[1];
    assign G[2] = B[1] ^ B[2];
    assign G[3] = B[2] ^ B[3];

endmodule

module barrel_shifter (
    input [3:0] A, // 4-bit input to shift
    input [3:0] S, // 4-bit shift amount
    output [3:0] Y // 4-bit shifted output
);

    assign Y = (S[3]) ? 4'b0000 : // shift left by 4 bits
                (S[2]) ? {A[1:0], A[3:2]} : // shift left by 2 bits
                (S[1]) ? {A[2:0], A[3]} : // shift right by 2 bits
                (S[0]) ? {A[3:1], A[0]} : // shift right by 1 bit
                         A; // no shift

endmodule

module xor_gate (
    input [3:0] A, // 4-bit input A
    input [3:0] B, // 4-bit input B
    output [3:0] G // 4-bit output
);

    assign G = A ^ B;

endmodule