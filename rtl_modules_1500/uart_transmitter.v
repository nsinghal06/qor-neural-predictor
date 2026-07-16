//917
module uart_transmitter (
  input clk,
  input rst,
  input [7:0] data_in,
  input start_bit,
  input stop_bit,
  output tx
);

parameter baud_rate = 9600;
reg [15:0] baud_counter;
reg [9:0] shift_reg;
reg tx_state;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    baud_counter <= 0;
    shift_reg <= 0;
    tx_state <= 1'b1;
  end else begin
    if (baud_counter == (50_000_000 / baud_rate) - 1) begin
      baud_counter <= 0;
      if (start_bit) begin
        shift_reg <= {stop_bit, data_in, 1'b0};
        tx_state <= 1'b0;
      end else if (!tx_state) begin
        shift_reg <= shift_reg >> 1;
        if (shift_reg == 1) begin
          tx_state <= 1'b1;
        end
      end
    end else begin
      baud_counter <= baud_counter + 1;
    end
  end
end

assign tx = tx_state;

endmodule

module uart_receiver (
  input clk,
  input rst,
  input rx,
  output [7:0] data_out,
  output valid_data
);

parameter baud_rate = 9600;
reg [15:0] baud_counter;
reg [9:0] shift_reg;
reg [3:0] state;
reg [7:0] data_buffer;
reg valid_data_reg;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    baud_counter <= 0;
    shift_reg <= 0;
    state <= 4'b0;
    data_buffer <= 0;
    valid_data_reg <= 1'b0;
  end else begin
    valid_data_reg <= 1'b0;
    if (baud_counter == (50_000_000 / baud_rate) - 1) begin
      baud_counter <= 0;
      case (state)
        4'b0000: begin
          if (!rx) begin
            state <= 4'b0001;
          end
        end
        4'b0001: begin
          state <= 4'b0010;
        end
        4'b0010: begin
          shift_reg <= {rx, shift_reg[9:1]};
          if (shift_reg[9]) begin
            state <= 4'b0100;
          end else begin
            state <= 4'b0011;
          end
        end
        4'b0011: begin
          state <= 4'b0100;
        end
        4'b0100: begin
          data_buffer <= shift_reg[8:1];
          valid_data_reg <= 1'b1;
          state <= 4'b0000;
        end
      endcase
    end else begin
      baud_counter <= baud_counter + 1;
    end
  end
end

assign data_out = data_buffer;
assign valid_data = valid_data_reg;

endmodule