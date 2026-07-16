//435
module shadow_pixel_blk_mem_gen
  (
   douta,
   clka,
   addra,
   dina,
   wea
   );

  output [11:0]douta;
  input clka;
  input [10:0]addra;
  input [11:0]dina;
  input [0:0]wea;

  reg [11:0]mem [0:4095];

  assign douta = mem[addra];

  always @(posedge clka) begin
    if (wea == 1'b1) begin
      mem[addra] <= dina;
    end
  end

endmodule