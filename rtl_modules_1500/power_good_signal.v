//1493
module power_good_signal (
    X,
    A1,
    A2,
    B1
);

    // Module ports
    output X;
    input A1;
    input A2;
    input B1;

    // Local signals
    wire and_out;
    wire or_out;

    // AND gate
    and and_gate (
        .out (and_out),
        .a (A1),
        .b (A2)
    );

    // OR gate
    or or_gate (
        .out (or_out),
        .a (and_out),
        .b (B1),
        .c (1'b0)
    );


    // Buffer
    buf buf_gate (
        .o (X),
        .i (or_out)
    );

endmodule