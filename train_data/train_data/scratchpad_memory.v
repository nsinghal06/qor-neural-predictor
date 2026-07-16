//421
module scratchpad_memory (
  input clk,
  input en,
  input wr,
  input [(depth>>1)-1:0] addr,
  input [width-1:0] din,
  output reg [width-1:0] dout
);

parameter depth = 1024; // number of memory locations
parameter width = 8; // width of each memory location

reg [width-1:0] mem [0:depth-1]; // array of registers to store memory locations

always @(posedge clk) begin
  if (en) begin
    dout <= mem[addr];
  end
  if (wr) begin
    mem[addr] <= din;
  end
end

endmodule