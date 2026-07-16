module qc16(
  output [7:0] counth, 
  output [7:0] countl, 
  input [1:0] tach, 
  input clk,
  input freeze,
  input invphase);
 
  wire [15:0] counter;
  wire up;
  wire down;
  reg [1:0] adjtach;
  
  always @(*) begin
    if(invphase) begin
      adjtach[0] = tach[1];
      adjtach[1] = tach[0];
    end
    else begin
      adjtach[0] = tach[0];
      adjtach[1] = tach[1];
    end
  end
  
  
  graycode2 gc2(
    .clk(clk), 
    .freeze(freeze),
    .up(up), 
    .down(down), 
    .tach(adjtach));
    
  udcounter16 udc16(
    .clk(clk),
    .up(up),
    .down(down),
    .counter(counter));
  
  assign counth = counter[15:8];
  assign countl = counter[7:0];
 
endmodule