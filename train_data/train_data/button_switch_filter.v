//1464
module button_switch_filter(
   // Outputs
   button_out, 
   SW_OK,
   // Inputs
   clk, 
   button, 
   SW
);
	input  clk;
	input  [3:0] button;
	input  [7:0] SW;
	output [3:0] button_out;
	output [7:0] SW_OK;

	glitch_filter G0(clk, button[0], button_out[0]);
	glitch_filter G1(clk, button[1], button_out[1]);
	glitch_filter G2(clk, button[2], button_out[2]);
	glitch_filter G3(clk, button[3], button_out[3]);
	glitch_filter G4(clk, SW[0], SW_OK[0]);
	glitch_filter G5(clk, SW[1], SW_OK[1]);
	glitch_filter G6(clk, SW[2], SW_OK[2]);
	glitch_filter G7(clk, SW[3], SW_OK[3]);
	glitch_filter G8(clk, SW[4], SW_OK[4]);
	glitch_filter G9(clk, SW[5], SW_OK[5]);
	glitch_filter G10(clk, SW[6], SW_OK[6]);
	glitch_filter G11(clk, SW[7], SW_OK[7]);

endmodule

module glitch_filter(
   input clk,
   input data_in,
   output reg data_out
);
   reg [1:0] shift_reg;

   always @(posedge clk) begin
      shift_reg <= {shift_reg[0], data_in};
   end

   always @* begin
      if (shift_reg == 2'b01 || shift_reg == 2'b10)
         data_out <= 1'b1;
      else
         data_out <= 1'b0;
   end
endmodule