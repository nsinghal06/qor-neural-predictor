//451
module logic_gate (
    X,
    A1,
    A2,
    B1,
    C1
);

    output X;
    input A1;
    input A2;
    input B1;
    input C1;

  
    // NOR gate implementation using transistors
   assign X = ~(A1 | A2 | B1 | C1);

endmodule