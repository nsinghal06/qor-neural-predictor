module mux_selector (
  input [2:0] sel,
  input [3:0] data0,
  input [3:0] data1,
  input [3:0] data2,
  input [3:0] data3,
  output [3:0] out
);

reg [3:0] out_reg;
assign out = out_reg;

always @* begin
    case (sel)
        3'b000: out_reg = data0;
        3'b001: out_reg = data1;
        3'b010: out_reg = data2;
        3'b011: out_reg = data3;
        default: out_reg = 4'bxxxx;
    endcase
end

endmodule