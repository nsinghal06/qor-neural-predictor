//1475
module bluetooth #(
  parameter baud_rate = 9600,
  parameter data_width = 8
)(
  input clk,
  input rst,
  input ctrl,
  input [data_width-1:0] data_in,
  output [data_width-1:0] data_out,
  output status
);


reg [data_width-1:0] tx_data;
reg [data_width-1:0] rx_data;
reg tx_busy;
reg rx_busy;
reg tx_done;
reg rx_done;
reg [3:0] tx_state;
reg [3:0] rx_state;
reg [7:0] tx_count;
reg [7:0] rx_count;

assign status = (tx_busy || rx_busy) ? 1'b1 : 1'b0;

// Bluetooth transmitter state machine
always @(posedge clk) begin
  if (rst) begin
    tx_state <= 4'b0000;
    tx_busy <= 1'b0;
    tx_done <= 1'b0;
    tx_count <= 8'd0;
  end else begin
    case (tx_state)
      4'b0000: begin // Idle state
        if (ctrl) begin
          tx_state <= 4'b0001;
          tx_busy <= 1'b1;
          tx_count <= 8'd0;
          tx_data <= data_in;
        end
      end
      4'b0001: begin // Start bit
        if (tx_count == baud_rate/2) begin
          tx_count <= 8'd0;
          tx_state <= 4'b0010;
        end else begin
          tx_count <= tx_count + 1;
        end
      end
      4'b0010: begin // Data bits
        if (tx_count == baud_rate) begin
          tx_count <= 8'd0;
          tx_state <= 4'b0011;
        end else begin
          tx_count <= tx_count + 1;
        end
      end
      4'b0011: begin // Stop bit
        if (tx_count == baud_rate/2) begin
          tx_count <= 8'd0;
          tx_state <= 4'b0100;
        end else begin
          tx_count <= tx_count + 1;
        end
      end
      4'b0100: begin // Done state
        tx_busy <= 1'b0;
        tx_done <= 1'b1;
        tx_state <= 4'b0000;
      end
    endcase
  end
end

// Bluetooth receiver state machine
always @(posedge clk) begin
  if (rst) begin
    rx_state <= 4'b0000;
    rx_busy <= 1'b0;
    rx_done <= 1'b0;
    rx_count <= 8'd0;
  end else begin
    case (rx_state)
      4'b0000: begin // Idle state
        if (ctrl) begin
          rx_state <= 4'b0001;
          rx_busy <= 1'b1;
          rx_count <= 8'd0;
        end
      end
      4'b0001: begin // Start bit
        if (rx_count == baud_rate/2) begin
          rx_count <= 8'd0;
          rx_state <= 4'b0010;
        end else begin
          rx_count <= rx_count + 1;
        end
      end
      4'b0010: begin // Data bits
        if (rx_count == baud_rate) begin
          rx_count <= 8'd0;
          rx_data <= {rx_data[data_width-2:0], data_in};
          rx_state <= 4'b0011;
        end else begin
          rx_count <= rx_count + 1;
        end
      end
      4'b0011: begin // Stop bit
        if (rx_count == baud_rate/2) begin
          rx_count <= 8'd0;
          rx_busy <= 1'b0;
          rx_done <= 1'b1;
          rx_state <= 4'b0000;
        end else begin
          rx_count <= rx_count + 1;
        end
      end
    endcase
  end
end

assign data_out = rx_data;

endmodule