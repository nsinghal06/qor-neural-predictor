module manchester_decoder (
  input wire [2*n-1:0] manchester_in,
  output wire [n-1:0] data_out,
  input wire clk
);

parameter n = 8; // number of bits in data signal

genvar i;
generate
  for (i = 0; i < n; i = i + 1) begin : manchester_decoding
    assign data_out[i] = (manchester_in[2*i] ^ clk);
  end
endgenerate

endmodule