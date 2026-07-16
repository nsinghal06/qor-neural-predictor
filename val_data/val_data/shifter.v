//462
module shifter (
    input [3:0] data,
    input rotate,
    output reg [3:0] shifted_data
);
always @(*) begin
    if (rotate) begin
        shifted_data[0] = data[3];
        shifted_data[1] = data[0];
        shifted_data[2] = data[1];
        shifted_data[3] = data[2];
    end
    else begin
        shifted_data = data;
    end
end
endmodule

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

module top_module (
    input [3:0] A,
    input [3:0] B,
    input SEL,
    output reg [3:0] OUT
);
reg [3:0] shifted_data;

// Instantiate shifter module
shifter shifter_inst (
    .data(A),
    .rotate(1'b1),
    .shifted_data(shifted_data)
);

// Instantiate mux_transmission_gate module
mux_transmission_gate mux_inst (
    .A(A),
    .B(shifted_data),
    .SEL(SEL),
    .OUT(OUT)
);

endmodule