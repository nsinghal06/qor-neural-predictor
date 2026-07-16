module b (
   input clk,
   input trig_i,
   output reg trig_o
   );

   integer count = 0;

   always @(posedge clk) begin
      if (trig_i && count == 0) begin
         trig_o <= 1;
         count <= 1;
      end else if (count > 0 && count < 4) begin
         trig_o <= 0;
         count <= count + 1;
      end else begin
         trig_o <= 1;
         count <= 0;
      end
   end

endmodule