//486
module adapter_ppfifo_2_axi_stream #(
  parameter DATA_WIDTH = 32,
  parameter STROBE_WIDTH = DATA_WIDTH / 8,
  parameter USE_KEEP = 0
)(
  input rst,

  //Ping Poing FIFO Read Interface
  input i_ppfifo_rdy,
  output reg o_ppfifo_act,
  input [23:0] i_ppfifo_size,
  input [(DATA_WIDTH + 1) - 1:0] i_ppfifo_data,
  output o_ppfifo_stb,

  //AXI Stream Output
  input i_axi_clk,
  output [3:0] o_axi_user,
  input i_axi_ready,
  output [DATA_WIDTH - 1:0] o_axi_data,
  output o_axi_last,
  output reg o_axi_valid,

  output [31:0] o_debug
);

  //local parameters
  localparam IDLE = 0;
  localparam READY = 1;
  localparam RELEASE = 2;

  //registes/wires
  reg [3:0] state;
  reg [23:0] r_count;

  //submodules
  //asynchronous logic
  assign o_axi_data = i_ppfifo_data[DATA_WIDTH - 1:0];
  assign o_ppfifo_stb = (i_axi_ready & o_axi_valid);

  assign o_axi_user[0] = (r_count < i_ppfifo_size) ? i_ppfifo_data[DATA_WIDTH] : 1'b0;
  assign o_axi_user[3:1] = 3'h0;

  assign o_axi_last = ((r_count + 1) >= i_ppfifo_size) & o_ppfifo_act & o_axi_valid;
  //synchronous logic
  assign o_debug[3:0] = state;
  assign o_debug[4] = (r_count < i_ppfifo_size) ? i_ppfifo_data[DATA_WIDTH] : 1'b0;
  assign o_debug[5] = o_ppfifo_act;
  assign o_debug[6] = i_ppfifo_rdy;
  assign o_debug[7] = (r_count > 0);
  assign o_debug[8] = (i_ppfifo_size > 0);
  assign o_debug[9] = (r_count == i_ppfifo_size);
  assign o_debug[15:10] = 0;
  assign o_debug[23:16] = r_count[7:0];
  assign o_debug[31:24] = 0;

  always @(posedge i_axi_clk) begin
    o_axi_valid <= 0;

    if (rst) begin
      state <= IDLE;
      o_ppfifo_act <= 0;
      r_count <= 0;
    end
    else begin
      case (state)
        IDLE: begin
          o_ppfifo_act <= 0;
          if (i_ppfifo_rdy && !o_ppfifo_act) begin
            r_count <= 0;
            o_ppfifo_act <= 1;
            state <= READY;
          end
        end
        READY: begin
          if (r_count < i_ppfifo_size) begin
            o_axi_valid <= 1;
            if (i_axi_ready && o_axi_valid) begin
              r_count <= r_count + 1;
              if ((r_count + 1) >= i_ppfifo_size) begin
                o_axi_valid <= 0;
              end
            end
          end
          else begin
            o_ppfifo_act <= 0;
            state <= RELEASE;
          end
        end
        RELEASE: begin
          state <= IDLE;
        end
        default: begin
        end
      endcase
    end
  end

endmodule