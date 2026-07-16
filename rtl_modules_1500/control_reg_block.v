//434
module control_reg_block #(
  parameter n = 4,
  parameter m = 2
) (
  input [n-1:0] ctrl,
  output [m-1:0] en
);

  // Define Boolean functions to determine enable signals
  assign en[0] = ctrl[0] & ctrl[1];
  assign en[1] = ctrl[2] | ctrl[3];

endmodule