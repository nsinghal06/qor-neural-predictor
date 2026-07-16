//1451
module AdlerChecksum (
  input clk,
  input [n-1:0] data_in,
  input reset,
  input start,
  output [31:0] checksum_out,
  output reg done
);

parameter n = 8; // number of data bits per byte

reg [15:0] s1;
reg [15:0] s2;
reg [31:0] expected_checksum;
reg [31:0] computed_checksum;
reg [31:0] data_count;
reg [1:0] state;

always @(posedge clk) begin
  if (reset) begin
    state <= 2'b00; // IDLE state
    s1 <= 16'h0000;
    s2 <= 16'h0000;
    expected_checksum <= 32'h00000000;
    computed_checksum <= 32'h00000000;
    data_count <= 32'h00000000;
    done <= 1'b0;
  end else begin
    case (state)
      2'b00: // IDLE state
        if (start) begin
          state <= 2'b01; // PROCESS state
          s1 <= 16'h0001;
          s2 <= 16'h0000;
          expected_checksum <= {s2, s1};
          data_count <= 32'h00000001;
        end
      2'b01: // PROCESS state
        begin
          s1 <= (s1 + data_in) % 16'hFFFF;
          s2 <= (s2 + s1) % 16'hFFFF;
          data_count <= data_count + 1;
          if (data_count == (n * 65521)) begin
            state <= 2'b10; // CHECK state
            computed_checksum <= {s2, s1};
          end
        end
      2'b10: // CHECK state
        begin
          if (computed_checksum == expected_checksum) begin
            done <= 1'b1;
          end else begin
            done <= 1'b0;
          end
          state <= 2'b00; // IDLE state
        end
    endcase
  end
end

assign checksum_out = computed_checksum;

endmodule