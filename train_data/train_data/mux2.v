//1159
module mux2(
  input wire [31:0] in0,
  input wire [31:0] in1,
  input wire select,
  input wire enable,
  output reg [31:0] out
);

  wire [31:0] mux_out;

  assign mux_out = select ? in1 : in0;

  always @ (posedge enable) begin
    if (enable) begin
      out <= mux_out;
    end else begin
      out <= 0;
    end
  end

endmodule