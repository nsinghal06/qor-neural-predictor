//773
module temperature_sensor(
  input clk,
  input reset,
  input [9:0] data,
  output reg [7:0] temp_celsius,
  output reg [7:0] temp_fahrenheit
);

parameter temp_offset = -10; // offset in Celsius

// ADC value register
reg [9:0] temp_adc;

// Internal temperature value in raw format
reg [15:0] temp_celsius_raw;

//always block for ADC value and temperature in raw format
always @(posedge clk) begin
  if (reset) begin
    temp_adc <= 0;
    temp_celsius_raw <= 0;
  end
  else begin
    temp_adc <= data;
    temp_celsius_raw <= temp_adc * 100 / 1023 - 50;
  end
end

//always block for temperature in Celsius and Fahrenheit
always @(*) begin
  temp_celsius = temp_celsius_raw[7:0] + temp_offset;
  temp_fahrenheit = ((temp_celsius + 40) * 9) / 5 + 32; // Convert Celsius to Fahrenheit
end

endmodule