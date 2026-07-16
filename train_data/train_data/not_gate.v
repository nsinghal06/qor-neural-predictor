module not_gate(input wire in, output reg out);
  always @* begin
    out = ~in;
  end
endmodule