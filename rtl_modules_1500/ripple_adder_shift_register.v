//267
module ripple_adder_shift_register (
    input clk,
    input reset,
    input [3:0] A,
    input [3:0] B,
    output [3:0] parallel_output,
    output serial_output
);

    wire [3:0] sum;
    ripple_carry_adder adder(.A(A), .B(B), .sum(sum));
    shift_register register(.clk(clk), .reset(reset), .parallel_input(sum), .parallel_output(parallel_output), .serial_output(serial_output));

endmodule

module ripple_carry_adder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] sum
);

    wire [3:0] carry;
    assign carry[0] = (A[0] & B[0]);
    assign carry[1] = (A[1] & B[1]) | (A[1] & carry[0]) | (B[1] & carry[0]);
    assign carry[2] = (A[2] & B[2]) | (A[2] & carry[1]) | (B[2] & carry[1]);
    assign carry[3] = (A[3] & B[3]) | (A[3] & carry[2]) | (B[3] & carry[2]);

    assign sum[0] = A[0] ^ B[0];
    assign sum[1] = A[1] ^ B[1] ^ carry[0];
    assign sum[2] = A[2] ^ B[2] ^ carry[1];
    assign sum[3] = A[3] ^ B[3] ^ carry[2];

endmodule

module shift_register (
    input clk,
    input reset,
    input [3:0] parallel_input,
    output [3:0] parallel_output,
    output serial_output
);

    reg [3:0] register;

    always @ (posedge clk) begin
        if (reset) begin
            register <= 4'b0000;
        end else begin
            register <= {register[2:0], parallel_input[3]};
        end
    end

    assign parallel_output = register;
    assign serial_output = register[3];

endmodule

module functional_module (
    input [3:0] serial_output,
    input [3:0] parallel_output,
    output [3:0] final_output
);

    assign final_output = serial_output + parallel_output;

endmodule