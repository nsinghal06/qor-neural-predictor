//1169
module memory_controller #(
  parameter n = 3, // number of address lines
  parameter m = 4 // number of data lines
)(
  input read,
  input write,
  input [n-1:0] address,
  input [m-1:0] data_in,
  input clk,
  output reg [m-1:0] data_out
);

reg [m-1:0] memory [2**n-1:0]; // memory array

always @ (posedge clk) begin
  if (write && !read) begin // write operation
    memory[address] <= data_in;
  end
end

always @* begin
  data_out <= (read && !write) ? memory[address] : 16'b0; // read operation
end

endmodule