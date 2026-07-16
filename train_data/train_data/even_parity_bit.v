//453
module even_parity_bit(
    input [7:0] in,
    output reg [8:0] out
);
    
    always @* begin
        out[8] = ~(in[0] ^ in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7]);
        out[7:0] = in;
    end
    
endmodule

module carry_select_adder(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output [31:0] sum
);
    
    wire [31:0] p, g, c0, c1, c2, c3;
    
    assign p = a ^ b;
    assign g = a & b;
    
    assign c0 = cin;
    assign c1 = g[0] | (p[0] & c0);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);
    
    assign sum = p ^ cin ^ (g & {c3, c2, c1, c0});
    
endmodule

module and_gate(
    input [8:0] a,
    input [31:0] b,
    output [8:0] out
);
    
    assign out = a & b[31:24];
    
endmodule

module top_module(
    input clk,
    input reset,
    input [7:0] in,
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum,
    output [8:0] parity_and_sum
);
    
    wire [8:0] parity;
    
    even_parity_bit parity_module(
        .in(in),
        .out(parity)
    );
    
    carry_select_adder adder(
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(sum)
    );
    
    and_gate and_module(
        .a(parity),
        .b(sum),
        .out(parity_and_sum)
    );
    
endmodule