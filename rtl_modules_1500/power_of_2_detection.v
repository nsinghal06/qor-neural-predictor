//691
module power_of_2_detection (
  input [3:0] num,
  output reg is_power_of_2
);

  always @(*) begin
    case(num)
      4'b0001: is_power_of_2 = 1;
      4'b0010: is_power_of_2 = 1;
      4'b0100: is_power_of_2 = 1;
      4'b1000: is_power_of_2 = 1;
      default: is_power_of_2 = 0;
    endcase
  end

endmodule