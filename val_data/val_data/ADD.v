module ADD
#(
    parameter N=32
)
(
    input [N-1:0] A,
    input [N-1:0] B,
    input CI,
    output [N-1:0] S,
    output CO
);

wire [N:0] Tmp;

assign Tmp = A + B + CI;
assign S = Tmp[N-1:0];
assign CO = Tmp[N];

endmodule