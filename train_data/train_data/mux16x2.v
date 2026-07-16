module mux16x2 (
    input [15:0] in1,
    input [15:0] in2,
    input sel,
    output [15:0] out
);

    assign out = (sel == 1'b0) ? in1 : in2;

endmodule