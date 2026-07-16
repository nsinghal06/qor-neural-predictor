//929
module lcd_driver (
  input clk,
  input rst,
  input [7:0] data,
  input rs,
  input en,
  output reg [7:0] lcd_data,
  output reg lcd_rs,
  output reg lcd_en
);

  // Internal registers
  reg [7:0] cgram_addr;
  reg [7:0] ddram_addr;
  reg [7:0] busy_flag;
  reg [7:0] instruction;
  reg [7:0] display_data;
  
  // Internal states
  parameter IDLE = 2'b00;
  parameter READ_BUSY_FLAG = 2'b01;
  parameter READ_ADDRESS = 2'b10;
  parameter WRITE_DATA = 2'b11;
  reg [1:0] state;
  
  always @(posedge clk) begin
    if (rst) begin
      // Reset all internal registers and states
      cgram_addr <= 8'b0;
      ddram_addr <= 8'b0;
      busy_flag <= 8'b0;
      instruction <= 8'b0;
      display_data <= 8'b0;
      state <= IDLE;
      
      // Reset all output signals
      lcd_data <= 8'b0;
      lcd_rs <= 1'b0;
      lcd_en <= 1'b0;
    end else begin
      case (state)
        IDLE: begin
          if (en) begin
            if (rs) begin
              // Write data to DDRAM or CGRAM
              state <= WRITE_DATA;
              lcd_data <= display_data;
              lcd_rs <= 1'b1;
              lcd_en <= 1'b1;
            end else begin
              // Execute instruction
              instruction <= data;
              if (instruction[7:4] == 4'b0000) begin
                // Clear display
                state <= READ_BUSY_FLAG;
                lcd_data <= 8'b00000001;
                lcd_rs <= 1'b0;
                lcd_en <= 1'b1;
              end else if (instruction[7:4] == 4'b0001) begin
                // Return home
                state <= READ_BUSY_FLAG;
                lcd_data <= 8'b00000010;
                lcd_rs <= 1'b0;
                lcd_en <= 1'b1;
              end else if (instruction[7:4] == 4'b0010) begin
                // Entry mode set
                state <= READ_BUSY_FLAG;
                lcd_data <= instruction;
                lcd_rs <= 1'b0;
                lcd_en <= 1'b1;
              end else if (instruction[7:4] == 4'b0011) begin
                // Display on/off control
                state <= READ_BUSY_FLAG;
                lcd_data <= instruction;
                lcd_rs <= 1'b0;
                lcd_en <= 1'b1;
              end else if (instruction[7:4] == 4'b0100 || instruction[7:4] == 4'b0101) begin
                // Cursor or display shift
                state <= READ_BUSY_FLAG;
                lcd_data <= instruction;
                lcd_rs <= 1'b0;
                lcd_en <= 1'b1;
              end else if (instruction[7:4] == 4'b0010) begin
                // Function set
                state <= READ_BUSY_FLAG;
                lcd_data <= instruction;
                lcd_rs <= 1'b0;
                lcd_en <= 1'b1;
              end else if (instruction[7:4] == 4'b0110 || instruction[7:4] == 4'b0111) begin
                // Set CGRAM address or DDRAM address
                state <= READ_ADDRESS;
                lcd_data <= instruction;
                lcd_rs <= 1'b0;
                lcd_en <= 1'b1;
              end else if (instruction[7:4] == 4'b1000 || instruction[7:4] == 4'b1001) begin
                // Read busy flag and address
                state <= READ_BUSY_FLAG;
                lcd_rs <= 1'b0;
                lcd_en <= 1'b1;
              end
            end
          end
        end
        
        READ_BUSY_FLAG: begin
          // Read busy flag and address
          lcd_data <= 8'b0;
          lcd_rs <= 1'b0;
          lcd_en <= 1'b1;
          state <= READ_ADDRESS;
        end
        
        READ_ADDRESS: begin
          // Read address
          busy_flag <= lcd_data;
          lcd_rs <= 1'b0;
          lcd_en <= 1'b0;
          if (instruction[7:4] == 4'b0110) begin
            // Set CGRAM address
            cgram_addr <= lcd_data;
          end else begin
            // Set DDRAM address
            ddram_addr <= lcd_data;
          end
          state <= IDLE;
        end
        
        WRITE_DATA: begin
          // Write data to DDRAM or CGRAM
          lcd_rs <= 1'b1;
          lcd_en <= 1'b0;
          if (instruction[7:4] == 4'b0100) begin
            // Write data to CGRAM
            state <= READ_ADDRESS;
            lcd_data <= cgram_addr;
          end else begin
            // Write data to DDRAM
            state <= IDLE;
          end
        end
      endcase
    end
  end
  
endmodule