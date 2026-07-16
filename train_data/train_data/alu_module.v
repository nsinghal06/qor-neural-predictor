module alu_module (
    input [3:0] A,
    input [3:0] B,
    input [2:0] OP,
    output  [3:0] Y
);

    reg [3:0] Y_reg;

    always @(*) begin
        case (OP)
            3'b000: Y_reg = A & B;
            3'b001: Y_reg = A | B;
            3'b010: Y_reg = A + B;
            3'b011: Y_reg = A - B;
            3'b100: Y_reg = A ^ B;
            3'b101: Y_reg = ~A;
            3'b110: Y_reg = A << 1;
            3'b111: Y_reg = A >> 1;
        endcase
    end

    assign Y = Y_reg;

endmodule