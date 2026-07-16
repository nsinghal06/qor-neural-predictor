//1326
module multi_port_RAM (
  input [n-1:0] d_in,
  input [n-1:0] we,
  input [n-1:0] re,
  input [n-1:0] addr,
  output reg [n-1:0] d_out, // Declared as reg
  input clk
);

parameter n = 4; // number of ports
parameter k = 8; // number of address bits
parameter m = 16; // number of data bits

reg [m-1:0] mem [2**k-1:0];

integer i;

always @ (posedge clk) begin
  for (i = 0; i < n; i = i + 1) begin
    if (we[i]) begin
      mem[addr[i]][m-1:0] <= d_in[i];
    end
    if (re[i]) begin
      d_out[i] <= mem[addr[i]][m-1:0];
    end
  end
end

endmodule