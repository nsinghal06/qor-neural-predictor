module nor3(
  input a,
  input b,
  input c,
  output reg out
);

  wire temp_out;

  nor2 u1 (.a(a), .b(b), .out(temp_out));
  assign temp_out = ~(a | b);
  always @* begin
    out = ~temp_out & ~c;
  end

endmodule