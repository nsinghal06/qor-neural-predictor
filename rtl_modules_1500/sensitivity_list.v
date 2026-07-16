//427
module sensitivity_list #(
  parameter ii = 4
)(
  input CLK,
  input A,
  input [ii-1:0] C,
  output reg [ii-1:0] B
);

reg [ii-1:0] prev_C;

always @(posedge CLK) begin
  prev_C <= C;
end

always @(A, C) begin
  B = A + C;
end

endmodule