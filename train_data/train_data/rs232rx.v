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