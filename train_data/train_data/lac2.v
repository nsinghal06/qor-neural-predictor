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