//851
module lookahead_carry_generator (c, gout, pout, Cin, g, p);
  output [2:0] c;
  output gout, pout;
  input Cin;
  input [2:0] g, p;

  wire [1:0] cint, gint, pint;  // cint: internal carry, gint: internal generate, pint: internal propagate

  lac2 leaf0(
     .c(cint[0]),
     .gout(gint[0]),
     .pout(pint[0]),
     .Cin(Cin),
     .g(g[0]),
     .p(p[0])
  );

  lac2 leaf1(
     .c(cint[1]),
     .gout(gint[1]),
     .pout(pint[1]),
     .Cin(cint[0]),
     .g(g[1]),
     .p(p[1])
  );

  lac root(
     .c(c),
     .gout(gout),
     .pout(pout),
     .Cin(cint[1]),
     .g({g[2], gint[1], gint[0]}),
     .p({p[1], pint[1], pint[0]})
  );

endmodule

module lac2 (c, gout, pout, Cin, g, p);
  output reg c;
  output reg gout, pout;
  input Cin;
  input g, p;

  always @(*) begin
    gout = g & (p | Cin);
    pout = g | p;
    c = pout & Cin | gout;
  end
endmodule

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