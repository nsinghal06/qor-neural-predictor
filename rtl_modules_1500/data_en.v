//503
module data_en (
   // Inputs
   input data_in,
   input enable,
   input reset_l,
   input clk,
   // Outputs
   output reg data_out
   );

   always @ (posedge clk) begin
      if (reset_l == 0) begin
         data_out <= 0;
      end else if (enable == 1) begin
         data_out <= data_in;
      end
   end

endmodule