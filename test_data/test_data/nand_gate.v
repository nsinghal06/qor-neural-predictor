//1366
module nand_gate(input a, b, output out);
  assign out = ~(a & b);
endmodule

module not_gate(input wire in, output reg out);
  always @* begin
    out = ~in;
  end
endmodule

module and_gate(input a, b, output out);
  assign out = a & b;
endmodule

module or_gate(input a, b, output out);
  wire and1_out, and2_out;
  and_gate and1(a, b, and1_out);
  and_gate and2(a, b, and2_out);
  assign out = and1_out | and2_out;
endmodule