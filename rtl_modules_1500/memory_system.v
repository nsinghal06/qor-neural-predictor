//1225
module memory_system #(
    parameter ADDR_WIDTH = 1,
    parameter DATA_WIDTH = 1
) (
input clk,
input en,
input we,
input [ADDR_WIDTH-1:0] addr,
input [DATA_WIDTH-1:0] din,
output [DATA_WIDTH-1:0] dout
);

parameter MEMSIZE = 1;

reg [DATA_WIDTH-1:0] mem [MEMSIZE-1:0];
reg [DATA_WIDTH-1:0] dout;

always @(posedge clk) begin
if (en) begin
if (we) begin
// write operation
mem[addr] <= din;
end else begin
// read operation
dout <= mem[addr];
end
end
end

endmodule