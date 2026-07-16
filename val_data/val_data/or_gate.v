module or_gate(input a, b, output out);
  wire and1_out, and2_out;
  and_gate and1(a, b, and1_out);
  and_gate and2(a, b, and2_out);
  assign out = and1_out | and2_out;
endmodule