module mux_transmission_gate (
    input [3:0] A,
    input [3:0] B,
    input SEL,
    output reg [3:0] OUT
);
always @(SEL, A, B) begin
    if (SEL) begin
        OUT = B;
    end
    else begin
        OUT = A;
    end
end
endmodule