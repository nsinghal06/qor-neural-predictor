//1459
module dff_pos_edge_trigger(CLK, D, Q);
  input CLK, D;
  output Q;
  reg Q;

  always @(posedge CLK) begin
    Q <= D;
  end

endmodule