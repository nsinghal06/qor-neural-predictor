module and_gate_2_input(
    input [1:0] in,
    output out
);

assign out = ~(in[0] & in[1]);

endmodule