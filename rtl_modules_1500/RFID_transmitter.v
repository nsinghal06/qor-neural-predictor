//942
module RFID_transmitter (
  input clk,
  input enable,
  input reset,
  input [7:0] data_in,
  output reg [7:0] data_out,
  output reg tx_en
);

  reg [7:0] counter;
  reg [7:0] modulated_data;
  reg [7:0] carrier_signal = 8'b11110000; // Arbitrary carrier signal
  
  always @(posedge clk) begin
    if (reset) begin
      counter <= 8'b0;
      modulated_data <= 8'b0;
      tx_en <= 1'b0;
    end else if (enable) begin
      counter <= counter + 1;
      if (counter == 8'd10) begin // Arbitrary counter value
        modulated_data <= data_in ^ carrier_signal; // XOR data with carrier signal
        data_out <= modulated_data;
        tx_en <= 1'b1;
      end else if (counter == 8'd20) begin // Arbitrary counter value
        modulated_data <= 8'b0;
        tx_en <= 1'b0;
        counter <= 8'b0;
      end
    end else begin
      modulated_data <= 8'b0;
      tx_en <= 1'b0;
      counter <= 8'b0;
    end
  end
  
endmodule

module RFID_receiver (
  input clk,
  input enable,
  input reset,
  input [7:0] data_in,
  output reg [7:0] data_out,
  output reg rx_en
);

  reg [7:0] counter;
  reg [7:0] demodulated_data;
  reg [7:0] carrier_signal = 8'b11110000; // Arbitrary carrier signal
  
  always @(posedge clk) begin
    if (reset) begin
      counter <= 8'b0;
      demodulated_data <= 8'b0;
      rx_en <= 1'b0;
    end else if (enable) begin
      counter <= counter + 1;
      if (counter == 8'd10) begin // Arbitrary counter value
        demodulated_data <= data_in ^ carrier_signal; // XOR data with carrier signal
        data_out <= demodulated_data;
        rx_en <= 1'b1;
      end else if (counter == 8'd20) begin // Arbitrary counter value
        demodulated_data <= 8'b0;
        rx_en <= 1'b0;
        counter <= 8'b0;
      end
    end else begin
      demodulated_data <= 8'b0;
      rx_en <= 1'b0;
      counter <= 8'b0;
    end
  end
  
endmodule