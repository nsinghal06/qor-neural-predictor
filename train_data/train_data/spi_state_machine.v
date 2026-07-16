//1116
module spi_state_machine (
  input clk,
  input rst,
  input mode,
  input [3:0] ssel,
  input [7:0] mosi,
  output reg [7:0] miso,
  output reg done,
  output reg [7:0] data
);

  // Define the states for the state machine
  parameter IDLE = 2'b00;
  parameter SEND = 2'b01;
  parameter RECEIVE = 2'b10;
  
  // Define the clock polarity and phase parameters
  parameter CPOL_0_CPHA_0 = 2'b00;
  parameter CPOL_0_CPHA_1 = 2'b01;
  parameter CPOL_1_CPHA_0 = 2'b10;
  parameter CPOL_1_CPHA_1 = 2'b11;
  
  // Define the data width parameter
  parameter DATA_WIDTH = 8;
  
  // Define the number of slave devices parameter
  parameter NUM_SLAVES = 4;
  
  // Define the state and output registers
  reg [1:0] state;
  reg [7:0] tx_data;
  reg [7:0] rx_data;
  reg done_reg;
  
  // Define the clock polarity and phase signals
  wire sclk;
  wire cpol;
  wire cpha;
  
  // Define the slave select signals
  reg [3:0] ssel_reg;
  reg [3:0] ssel_next;
  
  // Define the data signals
  reg mosi_reg;
  reg miso_next;
  
  // Define the counter for the data width
  reg [2:0] data_count;
  
  // Define the counter for the number of slave devices
  reg [1:0] slave_count;
  
  // Define the state machine
  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      tx_data <= 8'b0;
      rx_data <= 8'b0;
      done_reg <= 1'b0;
      data_count <= 3'b0;
      slave_count <= 2'b0;
    end else begin
      case (state)
        IDLE: begin
          if (mode) begin
            // Slave mode
            ssel_reg <= ssel;
            mosi_reg <= 1'b0;
            state <= RECEIVE;
          end else begin
            // Master mode
            ssel_reg <= NUM_SLAVES-1;
            mosi_reg <= tx_data[DATA_WIDTH-1];
            state <= SEND;
          end
        end
        SEND: begin
          // Shift out the data
          mosi_reg <= tx_data[DATA_WIDTH-2];
          tx_data <= {tx_data[DATA_WIDTH-2:0], miso_next};
          data_count <= data_count + 1;
          if (data_count == DATA_WIDTH) begin
            data_count <= 3'b0;
            state <= RECEIVE;
          end
        end
        RECEIVE: begin
          // Shift in the data
          miso_next <= 1'b0;
          if (cpol && cpha) begin
            miso_next <= miso_next | mosi;
          end
          if (cpol && !cpha) begin
            miso_next <= miso_next | (mosi << 1);
          end
          if (!cpol && cpha) begin
            miso_next <= miso_next | (mosi >> 1);
          end
          if (!cpol && !cpha) begin
            miso_next <= miso_next | (mosi << 7);
          end
          data_count <= data_count + 1;
          if (data_count == DATA_WIDTH) begin
            data_count <= 3'b0;
            rx_data <= miso_next;
            done_reg <= 1'b1;
            if (mode) begin
              // Slave mode
              state <= RECEIVE;
            end else begin
              // Master mode
              tx_data <= {tx_data[DATA_WIDTH-2:0], 8'b0};
              state <= SEND;
            end
          end
        end
      endcase
      if (mode) begin
        // Slave mode
        ssel_next <= ssel;
        miso <= rx_data;
      end else begin
        // Master mode
        ssel_next <= slave_count;
        miso <= miso_next;
      end
      if (done_reg) begin
        done <= 1'b1;
        data <= rx_data;
      end else begin
        done <= 1'b0;
        data <= 8'b0;
      end
      if (mode) begin
        // Slave mode
        if (ssel_reg != ssel_next) begin
          state <= IDLE;
        end
      end else begin
        // Master mode
        if (data_count == 3'b0 && slave_count == NUM_SLAVES-1) begin
          state <= IDLE;
        end else if (data_count == 3'b0) begin
          slave_count <= slave_count + 1;
        end
      end
    end
  end
  
  // Generate the clock polarity and phase signals
  assign sclk = clk;
  assign cpol = (mode) ? mosi_reg : ssel_reg[0];
  assign cpha = (mode) ? ssel_reg[1] : ssel_reg[slave_count+2];
  
endmodule