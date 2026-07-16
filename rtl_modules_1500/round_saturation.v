//324
module round_saturation #(
  parameter i = 8, // number of integer bits
  parameter f = 8, // number of fractional bits
  parameter s = 8  // number of scaling bits
) (
  input [i+f-1:0] x, // fixed-point number with i integer bits and f fractional bits
  input [s-1:0] scale, // scaling factor
  output [i+f-1:0] y // rounded and saturated fixed-point number
);


parameter max_val = 2**(i+f-1)-1; // maximum representable value
parameter min_val = -2**(i+f-1); // minimum representable value

wire [i+f-1:0] scaled; // scaled fixed-point number
wire [i+f-1:0] rounded; // rounded fixed-point number

assign scaled = x * scale; // scale the input fixed-point number
assign rounded = scaled + (scaled >= (1<<(f-1))) - (scaled <= -(1<<(f-1))); // round the scaled number

assign y = (rounded > max_val) ? max_val : ((rounded < min_val) ? min_val : rounded); // saturate the rounded number if it exceeds the range of the fixed-point format

endmodule