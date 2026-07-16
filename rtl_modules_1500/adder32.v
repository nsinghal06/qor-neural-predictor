//977
module adder32 (
  input [31:0] A,
  input [31:0] B,
  input CI,
  output [31:0] SUM,
  output CO
);

  wire [31:0] C;
  wire [31:0] S;

  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) begin : fa_gen
      full_adder fa (
        .A(A[i]),
        .B(B[i]),
        .CI(i == 0 ? CI : C[i-1]),
        .S(S[i]),
        .CO(C[i])
      );
    end
  endgenerate

  assign SUM = S;
  assign CO = C[31];

endmodule

module full_adder (
  input A,
  input B,
  input CI,
  output S,
  output CO
);

  assign S = A ^ B ^ CI;
  assign CO = (A & B) | (CI & (A ^ B));

endmodule