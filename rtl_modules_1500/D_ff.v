//816
module D_ff(
    input Clk,
    input D,
    input Clear,
    output Q
);

    reg Q;

    always @(posedge Clk) begin
        if (Clear) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end

endmodule

module counters_8bit_with_TD_ff(
    input Clk,
    input Enable,
    input Clear,
    output [7:0] Q
);

    // Define D Flip-Flops as building blocks
    D_ff SR0 (Clk, Enable, Clear, Q[0]);
    D_ff SR1 (Clk, Enable & Q[0], Clear, Q[1]);
    D_ff SR2 (Clk, Enable & Q[0] & Q[1], Clear, Q[2]);
    D_ff SR3 (Clk, Enable & Q[0] & Q[1] & Q[2], Clear, Q[3]);
    D_ff SR4 (Clk, Enable & Q[0] & Q[1] & Q[2] & Q[3], Clear, Q[4]);
    D_ff SR5 (Clk, Enable & Q[0] & Q[1] & Q[2] & Q[3] & Q[4], Clear, Q[5]);
    D_ff SR6 (Clk, Enable & Q[0] & Q[1] & Q[2] & Q[3] & Q[4] & Q[5], Clear, Q[6]);
    D_ff SR7 (Clk, Enable & Q[0] & Q[1] & Q[2] & Q[3] & Q[4] & Q[5] & Q[6], Clear, Q[7]);

endmodule