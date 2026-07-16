module mux_3to4 (
    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [1:0] s,
    output [3:0] w
);
    assign w[0] = a[0] & ~s[1] & ~s[0] | b[0] & ~s[1] & s[0] | c[0] & s[1] & ~s[0];
    assign w[1] = a[1] & ~s[1] & ~s[0] | b[1] & ~s[1] & s[0] | c[1] & s[1] & ~s[0];
    assign w[2] = a[2] & ~s[1] & ~s[0] | b[2] & ~s[1] & s[0] | c[2] & s[1] & ~s[0];
    assign w[3] = a[3] & ~s[1] & ~s[0] | b[3] & ~s[1] & s[0] | c[3] & s[1] & ~s[0];
endmodule