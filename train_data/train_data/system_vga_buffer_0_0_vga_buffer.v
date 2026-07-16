module system_vga_buffer_0_0_vga_buffer
   (clk_r,
    clk_w,
    data_r,
    data_w,
    wen,
    x_addr_r,
    x_addr_w,
    y_addr_r,
    y_addr_w);
  input clk_r;
  input clk_w;
  output [23:0]data_r;
  input [23:0]data_w;
  input wen;
  input [9:0]x_addr_r;
  input [9:0]x_addr_w;
  input [9:0]y_addr_r;
  input [9:0]y_addr_w;

  reg [23:0]mem[0:1023];
  reg [2:0]addr_r;
  reg [2:0]addr_w;
  
  assign data_r = {mem[addr_r],mem[addr_r+1],mem[addr_r+2]};

  always @(posedge clk_w) begin
    if (wen) begin
      mem[{y_addr_w, x_addr_w}] <= data_w;
    end
  end

  always @(posedge clk_r) begin
    addr_r <= {1'b0,y_addr_r};
    addr_w <= {1'b0,y_addr_w, x_addr_w};
  end
endmodule