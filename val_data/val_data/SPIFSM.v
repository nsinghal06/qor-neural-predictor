//1406
module SPIFSM (
  input Reset_n_i, // Reset signal
  input Clk_i, // Clock signal
  // FSM control
  input Start_i, // Start signal for the FSM
  output Done_o, // Done signal for the FSM
  output [7:0] Byte0_o, // Byte 0 of data to be sent/received
  output [7:0] Byte1_o, // Byte 1 of data to be sent/received
  // to/from SPI_Master
  input SPI_Transmission_i, // Transmission signal for SPI
  output SPI_Write_o, // Write signal for SPI
  output SPI_ReadNext_o, // Read signal for SPI
  output [7:0] SPI_Data_o, // Output data for SPI
  input [7:0] SPI_Data_i, // Input data for SPI
  input SPI_FIFOFull_i, // Full signal for SPI FIFO
  input SPI_FIFOEmpty_i, // Empty signal for SPI FIFO
  // to ADT7310
  output ADT7310CS_n_o, // Chip select signal for the sensor
  // parameters
  input [15:0] ParamCounterPreset_i // Preset for SPI counter
);

  // Internal signals
  reg [15:0] Counter_r; // Counter for SPI transmission
  reg [1:0] State_r; // State register for the FSM
  reg [1:0] NextState_r; // Next state register for the FSM
  reg [7:0] Byte0_r; // Byte 0 of data to be sent/received
  reg [7:0] Byte1_r; // Byte 1 of data to be sent/received
  wire StartTransfer_w; // Signal to start SPI transfer

  // FSM state encoding
  parameter [1:0] IDLE = 2'b00;
  parameter [1:0] START = 2'b01;
  parameter [1:0] TRANSMIT_BYTE0 = 2'b10;
  parameter [1:0] TRANSMIT_BYTE1 = 2'b11;

  // Output logic
  assign Done_o = (State_r == IDLE);
  assign Byte0_o = Byte0_r;
  assign Byte1_o = Byte1_r;
  assign ADT7310CS_n_o = (State_r != IDLE);
  assign SPI_Write_o = (State_r == TRANSMIT_BYTE0);
  assign SPI_ReadNext_o = (State_r == TRANSMIT_BYTE1);
  assign SPI_Data_o = (State_r == TRANSMIT_BYTE0) ? Byte0_r : Byte1_r;

  // State transition logic
  always @(posedge Clk_i, negedge Reset_n_i) begin
    if (!Reset_n_i) begin
      State_r <= IDLE;
    end else begin
      State_r <= NextState_r;
    end
  end

  // Next state logic
  always @(*) begin
    case (State_r)
      IDLE: begin
        if (Start_i) begin
          NextState_r = START;
        end else begin
          NextState_r = IDLE;
        end
      end
      START: begin
        NextState_r = TRANSMIT_BYTE0;
      end
      TRANSMIT_BYTE0: begin
        if (SPI_FIFOFull_i) begin
          NextState_r = TRANSMIT_BYTE0;
        end else begin
          NextState_r = TRANSMIT_BYTE1;
        end
      end
      TRANSMIT_BYTE1: begin
        if (SPI_FIFOFull_i) begin
          NextState_r = TRANSMIT_BYTE1;
        end else begin
          NextState_r = IDLE;
        end
      end
    endcase
  end

  // Counter logic
  always @(posedge Clk_i, negedge Reset_n_i) begin
    if (!Reset_n_i) begin
      Counter_r <= 0;
    end else if (StartTransfer_w) begin
      Counter_r <= ParamCounterPreset_i;
    end else if (Counter_r > 0) begin
      Counter_r <= Counter_r - 1;
    end
  end

  // Start transfer logic
  assign StartTransfer_w = (State_r == START);

  // Byte data logic
  always @(posedge Clk_i, negedge Reset_n_i) begin
    if (!Reset_n_i) begin
      Byte0_r <= 0;
      Byte1_r <= 0;
    end else if (StartTransfer_w) begin
      Byte0_r <= 8'h1A; // Command byte for ADT7310
      Byte1_r <= 8'h00; // Configuration byte for ADT7310
    end
  end

endmodule