module sync_to_async_synchronizer (
  input wire sync_in,
  input wire clk,
  input wire rst,
  output reg asyc_out
);

reg sync_ff;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    sync_ff <= 1'b0;
  end else begin
    sync_ff <= sync_in;
  end
end

always @* begin
  asyc_out = sync_ff;
end

endmodule