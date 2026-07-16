//1112
module status_token_fifo (
  input clk, reset,
  input [23:0] status_token_fifo_data,
  input status_token_fifo_rdreq, status_token_fifo_wrreq,
  output status_token_fifo_empty, status_token_fifo_full,
  output [23:0] status_token_fifo_q
);

  localparam FIFO_DEPTH = 2;
  localparam FIFO_WIDTH = 24;

  reg [FIFO_DEPTH-1:0] mem;
  reg [FIFO_WIDTH-1:0] mem_q;
  reg full_flag;
  reg empty_flag;
  reg rdptr;
  reg [1:0] wrptr;
  reg [2:0] wrptr_inc;
  reg [2:0] rdptr_inc;
  
  assign status_token_fifo_empty = empty_flag;
  assign status_token_fifo_full = full_flag;
  assign status_token_fifo_q = mem_q;

  always @* begin
    // Determine write pointer increment
    if (wrptr == FIFO_DEPTH - 1) begin
      wrptr_inc = 3'b000;
    end else begin
      wrptr_inc = 3'b001;
    end
    
    // Determine read pointer increment
    if (rdptr == FIFO_DEPTH - 1) begin
      rdptr_inc = 3'b000;
    end else begin
      rdptr_inc = 3'b001;
    end
  end
  
  always @(posedge clk) begin
    if (reset) begin
      mem <= 'h0;
      mem_q <= 'h0;
      full_flag <= 0;
      empty_flag <= 1;
      rdptr <= 0;
      wrptr <= 0;
    end else begin
      if (status_token_fifo_wrreq) begin
        if (!full_flag) begin
          mem[wrptr] <= status_token_fifo_data;
          wrptr <= wrptr + wrptr_inc;
        end
      end
      if (status_token_fifo_rdreq) begin
        if (!empty_flag) begin
          mem_q <= mem[rdptr];
          rdptr <= rdptr + rdptr_inc;
        end
      end
    end
    // Handle full and empty flags
    if (wrptr == rdptr) begin
      empty_flag <= (wrptr == 0);
      full_flag <= 1;
    end else begin
      empty_flag <= 0;
      full_flag <= (wrptr == rdptr - 1);
    end
  end
endmodule