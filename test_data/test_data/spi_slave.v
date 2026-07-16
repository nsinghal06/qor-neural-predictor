//417
module spi_slave #(
    parameter DATA_WIDTH = 8,
    parameter CS_WIDTH = 4
) (
    input wire clk,
    input wire rst_n,
    input wire SCK,
    output reg [DATA_WIDTH-1:0] MOSI,
    input wire [DATA_WIDTH-1:0] MISO,
    input wire [CS_WIDTH-1:0] CS
);

// Internal Variables
reg [DATA_WIDTH-1:0] data_reg;
reg [3:0] bit_cnt;
reg [DATA_WIDTH-1:0] mosi_buffer;

// SPI Operation
always @(posedge SCK or negedge rst_n) begin
    if (!rst_n) begin
        bit_cnt <= 0;
        data_reg <= 0;
        MOSI <= 0;
        mosi_buffer <= 0; // Initialize here instead of in a separate always block
    end else if (CS == 0) begin // Assuming active low CS
        if (bit_cnt < DATA_WIDTH) begin
            MOSI <= mosi_buffer[DATA_WIDTH-1];
            mosi_buffer <= mosi_buffer << 1;
            data_reg <= (data_reg << 1) | MISO;
            bit_cnt <= bit_cnt + 1;
        end else if (bit_cnt == DATA_WIDTH) begin
            bit_cnt <= 0;
            mosi_buffer <= data_reg; 
        end
    end
end

endmodule