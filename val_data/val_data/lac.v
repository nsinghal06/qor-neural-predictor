module lac (c, gout, pout, Cin, g, p);
  output reg [2:0] c;
  output reg gout, pout;
  input Cin;
  input [2:0] g, p;

  always @(*) begin
    gout = g[0] & g[1] & g[2] | g[0] & g[1] & Cin | g[0] & g[2] & Cin | g[1] & g[2] & Cin;
    pout = g[0] | g[1] | g[2];
    c[1] = pout & Cin | gout;
    c[0] = p[0] & Cin | g[0] & p[1] | g[1] & p[0] | g[2] & p[0];
    c[2] = g[2] | pout & g[1] | pout & g[0] & p[2] | gout & p[1] & p[0];
  end
endmodule