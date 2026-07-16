//635
module sync_fifo
  #(
    parameter depth = 32,
    parameter width = 32,
    parameter log2_depth = $clog2(depth),
    parameter log2_depthp1 = $clog2(depth+1)
    )
  (
   input clk,
   input reset,
   input wr_enable,
   input rd_enable,
   output reg empty,
   output reg full,
   output [width-1:0] rd_data,
   input [width-1:0] wr_data,
   output reg [log2_depthp1-1:0] count
   );

  reg [log2_depth-1:0] rd_ptr;
  reg [log2_depth-1:0] wr_ptr;
  wire writing = wr_enable && (rd_enable || !full);
  wire reading = rd_enable && !empty;
  reg [width-1:0] mem [depth-1:0];
  reg [log2_depth-1:0] next_rd_ptr;
  reg [log2_depth-1:0] next_wr_ptr;

  assign rd_data = mem[rd_ptr];

  always @(*) begin
    if (reset) begin
      next_rd_ptr = 0;
      next_wr_ptr = 0;
    end
    else if (reading) begin
      next_rd_ptr = rd_ptr + 1;
    end
    else begin
      next_rd_ptr = rd_ptr;
    end

    if (writing) begin
      next_wr_ptr = wr_ptr + 1;
    end
    else begin
      next_wr_ptr = wr_ptr;
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      rd_ptr <= 0;
      wr_ptr <= 0;
      empty <= 1;
      full <= 0;
      count <= 0;
    end
    else begin
      rd_ptr <= next_rd_ptr;
      wr_ptr <= next_wr_ptr;
      empty <= (next_rd_ptr == next_wr_ptr) && !writing;
      full <= (next_rd_ptr == next_wr_ptr) && writing;
      if (writing && !reading) begin
        mem[wr_ptr] <= wr_data;
        count <= count + 1;
      end
      else if (reading && !writing) begin
        count <= count - 1;
      end
    end
  end

endmodule