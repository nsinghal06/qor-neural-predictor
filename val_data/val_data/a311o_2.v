module a311o_2(
    output X,
    input A1,
    input A2,
    input A3,
    input B1,
    input C1
);

    // Intermediate wires for internal logic
    wire A_out;
    wire BC_out;

    // Logical OR for A inputs
    assign A_out = A1 | A2 | A3;

    // Logical AND for B and C inputs
    assign BC_out = B1 & C1;

    // Combining the results - Assuming an XOR function for illustration
    assign X = A_out ^ BC_out;

endmodule