//108
module UartDemux(
  input clk, 
  input RESET, 
  input UART_RX, 
  output reg [7:0] data, 
  output reg [7:0] addr, 
  output reg write, 
  output reg checksum_error
);
  wire [7:0] indata;
  wire       insend;
  Rs232Rx uart(.clk(clk), .rst(RESET), .rx(UART_RX), .din(indata), .send(insend));

  reg [1:0] state = 0;
  reg [7:0] cksum;
  reg [7:0] count;
  wire [7:0] new_cksum = cksum + indata;

  always @(posedge clk) begin
    if (RESET) begin
      write <= 0;
      state <= 0;
      count <= 0;
      cksum <= 0;
      addr <= 0;
      data <= 0;
      checksum_error <= 0;
    end else begin
      write <= 0;
      if (insend) begin
        cksum <= new_cksum;
        count <= count - 8'd1;
        if (state == 0) begin
          state <= 1;
          cksum <= indata;
        end else if (state == 1) begin
          addr <= indata;
          state <= 2;
        end else if (state == 2) begin
          count <= indata;
          state <= 3;
        end else begin
          data <= indata;
          write <= 1;
          if (count == 1) begin
            state <= 0;
            if (new_cksum != 0)
              checksum_error <= 1;
          end
        end
      end
    end
  end
endmodule

module Rs232Rx(
  input  clk,
  input  rst,
  input  rx,
  output reg [7:0] din,
  output reg send
);
reg [3:0] bitcnt;
reg [7:0] datacnt;
reg [7:0] data;
always @(posedge clk)begin
  if(rst)begin
    bitcnt<=4'b0000;
    datacnt<=8'b00000000;
    data<=8'h00;
    send<=1'b0;
  end
  else if(rx==1)begin
    datacnt<=8'b00000000;
    bitcnt<=4'b0000;
    send<=1'b0;
  end
  else begin
    if(bitcnt<4)begin
      bitcnt<=bitcnt+4'b0001;
      data<={data[6:0],rx};
    end
    else if(bitcnt==4)begin
      bitcnt<=bitcnt+4'b0001;
      datacnt<=datacnt+8'b00000001;
      if(datacnt==8)begin
        din<=data;
        send<=1'b1;
        bitcnt<=4'b0000;
      end
    end
  end
end
endmodule