//15
module seq_detector (
  input in,
  output reg out
);

parameter n = 4; // number of bits in the input sequence
parameter sequence = 4'b1101; // specific pattern to detect

reg [n-1:0] state; // state register
reg [n-1:0] seq_reg; // sequence register

always @(posedge in) begin
  seq_reg <= {seq_reg[n-2:0], in}; // shift in new input
  case (state)
    0: if (seq_reg == sequence) begin
         out <= 1; // output signal when sequence is detected
         state <= n-1; // transition to final state
       end else begin
         out <= 0;
         state <= 0; // reset to initial state
       end
    default: if (seq_reg == sequence) begin
               out <= 1; // output signal when sequence is detected
               state <= n-1; // transition to final state
             end else begin
               out <= 0;
               state <= state - 1; // transition to next state
             end
  endcase
end

endmodule