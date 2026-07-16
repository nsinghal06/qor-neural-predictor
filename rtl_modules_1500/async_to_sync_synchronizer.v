//663
module async_to_sync_synchronizer (
  input wire asyc_in,
  output reg sync_out,
  input wire clk,
  input wire rst
);

reg [1:0] sync_ff;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    sync_ff <= 2'b00;
  end else begin
    sync_ff <= {sync_ff[0], asyc_in};
  end
end

always @* begin
  sync_out = (sync_ff[1] == sync_ff[0]) ? sync_ff[1] : 1'b0;
end

endmodule

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