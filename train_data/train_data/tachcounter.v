module tachcounter(
    output [7:0] countl,
	output [7:0] counth,
    input clk,
    input filterce,
    input freeze,
    input invphase,
    input [1:0] tach);
  
  wire [1:0] filttach;
  
  qc16 q16(
    .clk(clk),
    .tach(filttach),
    .freeze(freeze),
    .invphase(invphase),
    .countl(countl),
    .counth(counth));
  
  digitalfilter filterph0(
    .clk(clk),
    .ce(filterce),
    .in(tach[0]),
    .out(filttach[0]));
  
  digitalfilter filterph1(
    .clk(clk),
    .ce(filterce),
    .in(tach[1]),
    .out(filttach[1]));
  
endmodule