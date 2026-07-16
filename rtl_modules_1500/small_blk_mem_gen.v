//676
module small_blk_mem_gen (
    douta,
    clka,
    addra,
    dina,
    wea
);

  // Define inputs and outputs
  output [11:0] douta;
  input clka;
  input [9:0] addra;
  input [11:0] dina;
  input wea;

  // Use RAMB18E1 megafunction instead of behavioral model
  
  reg [11:0] RAM [1023:0];

  always @(posedge clka) begin
    if (wea) RAM[addra] <= dina;
  end

  assign douta = RAM[addra];

endmodule