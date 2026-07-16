//1426
module karnaugh_map(
  input wire A, B, C, D,
  output reg F
);

  always @(*)
  begin
    case ({A,B,C,D})
      4'b0000: F = 1;
      4'b0001: F = 0;
      4'b0011: F = 1;
      4'b0010: F = 0;
      4'b0110: F = 1;
      4'b0111: F = 0;
      4'b1111: F = 1;
      4'b1110: F = 0;
      default: F = 0;
    endcase
  end

endmodule