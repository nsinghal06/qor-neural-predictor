module small_adder (
    input clk,
    input ce,
    input [63:0] a,
    input [63:0] b,
    output [63:0] s,
    output faccout2_co2,
    output faccout_ini
);

    // Instantiate the adder_64 module
    adder_64 adder_inst (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .cout(faccout2_co2)
    );

    // Additional logic for faccout_ini
    assign faccout_ini = 1'b0;

endmodule