module dp_receiver (
  input clk,
  input rst_n,
  input dp_data,
  input dp_clk,
  input dp_h_sync,
  input dp_v_sync,
  output reg [23:0] video_data,
  output reg h_sync,
  output reg v_sync,
  output reg pixel_clock,
  output reg video_enable
);

  reg [23:0] data_reg;
  reg [1:0] state;
  reg [7:0] count;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      state <= 2'b00;
      count <= 8'd0;
      video_data <= 24'h0;
      h_sync <= 1'b0;
      v_sync <= 1'b0;
      pixel_clock <= 1'b0;
      video_enable <= 1'b0;
    end else begin
      case (state)
        2'b00: begin // idle state
          video_data <= 24'h0;
          h_sync <= 1'b0;
          v_sync <= 1'b0;
          pixel_clock <= 1'b0;
          video_enable <= 1'b0;
          if (dp_v_sync && !dp_h_sync && !dp_clk && dp_data) begin
            state <= 2'b01; // start of frame
            count <= 8'd0;
          end
        end
        2'b01: begin // start of frame
          video_data <= 24'h0;
          h_sync <= 1'b0;
          v_sync <= 1'b0;
          pixel_clock <= 1'b0;
          video_enable <= 1'b0;
          if (count < 8'd4) begin
            v_sync <= 1'b1;
            count <= count + 1;
          end else begin
            state <= 2'b10; // receive data
            count <= 8'd0;
          end
        end
        2'b10: begin // receive data
          video_data <= {video_data[22:0], dp_data};
          pixel_clock <= dp_clk;
          if (count < 8'd3) begin
            h_sync <= 1'b1;
            count <= count + 1;
          end else begin
            count <= 8'd0;
            if (video_data == 24'h0) begin
              state <= 2'b11; // end of frame
            end
          end
        end
        2'b11: begin // end of frame
          video_data <= 24'h0;
          h_sync <= 1'b0;
          v_sync <= 1'b0;
          pixel_clock <= 1'b0;
          video_enable <= 1'b1;
          if (count < 8'd4) begin
            v_sync <= 1'b1;
            count <= count + 1;
          end else begin
            state <= 2'b00; // idle
            count <= 8'd0;
          end
        end
      endcase
    end
  end
endmodule