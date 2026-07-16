//1414
module async_reset_release (
  input reset,
  input clk,
  input data_in,
  output reg data_out
);

  always @(posedge clk or posedge reset) begin // posedge instead of negedge
    if (reset == 1'b1) begin
      data_out <= 1'b0; // Set data_out to default value when reset is high
    end
    else begin
      data_out <= data_in; // Set data_out to data_in when reset transitions from high to low or on every clock edge
    end
  end
endmodule