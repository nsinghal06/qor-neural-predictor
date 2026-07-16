//1144
module retiming_block (
  input clk, // clock signal
  input rst, // reset signal
  input din, // data input signal
  output dout // data output signal
);

parameter n = 4; // number of pipeline stages

wire [n-1:0] q; // array of pipeline stage outputs

// instantiate n flip-flops in a pipeline
genvar i;
generate
  for (i = 0; i < n; i = i + 1) begin : flip_flop_instance
    flip_flop ff (
      .clk(clk),
      .rst(rst),
      .din(i == 0 ? din : q[i-1]),
      .dout(q[i])
    );
  end
endgenerate

// output the last pipeline stage output
assign dout = q[n-1];

endmodule

module flip_flop (
  input clk, // clock signal
  input rst, // reset signal
  input din, // data input signal
  output reg dout // data output signal
);

always @(posedge clk, posedge rst) begin
  if (rst) begin
    dout <= 0;
  end else begin
    dout <= din;
  end
end

endmodule