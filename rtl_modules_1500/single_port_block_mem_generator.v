//510
module single_port_block_mem_generator
  #(
    parameter MEM_DEPTH = 4096,
    parameter MEM_WIDTH = 12
  )
  (
    input clk,
    input [MEM_WIDTH-1:0] din,
    input [MEM_WIDTH-1:0] addr,
    input we,
    output reg [MEM_WIDTH-1:0] dout
  );

  reg [MEM_WIDTH-1:0] mem [0:MEM_DEPTH-1];

  always @(posedge clk) begin
    if (we) begin
      mem[addr] <= din;
    end
    dout <= mem[addr];
  end

endmodule