//308
module memory_generator #(
  parameter WORD_SIZE = 64,
  parameter ADDR_SIZE = 4
)
  (
   output reg [WORD_SIZE-1:0] dout,
   input wr_clk,
   input rd_clk,
   input E,
   input tmp_ram_rd_en,
   input out,
   input [ADDR_SIZE-1:0] Q,
   input [WORD_SIZE-1:0] din
  );

  reg [ADDR_SIZE-1:0] addr;
  reg [WORD_SIZE-1:0] mem [0:(1<<ADDR_SIZE)-1];
  reg [WORD_SIZE-1:0] tmp_ram;
  reg tmp_ram_valid;

  always @(posedge wr_clk) begin
    if (E) begin
      mem[addr] <= din;
    end
  end

  always @(posedge rd_clk) begin
    if (E) begin
      case (out)
        0: dout <= mem[addr];
        1: dout <= tmp_ram;
        2: begin
          dout <= mem[addr];
          tmp_ram <= mem[addr];
          tmp_ram_valid <= 1;
        end
        3: begin
          if (tmp_ram_valid) begin
            dout <= tmp_ram;
          end else begin
            dout <= mem[addr];
          end
        end
        default: dout <= 0;
      endcase
    end
  end

  always @(posedge rd_clk) begin
    if (tmp_ram_rd_en) begin
      tmp_ram_valid <= 0;
    end
  end

  always @(posedge wr_clk) begin
    if (E) begin
      addr <= Q;
    end
  end

endmodule