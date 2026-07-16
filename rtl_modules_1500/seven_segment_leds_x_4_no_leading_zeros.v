//973
module seven_segment_leds_x_4_no_leading_zeros(
    input [15:0] bcd_in,
    input [3:0] decimal_points,
    input clk,
    output  reg [6:0] a_to_g,
    output reg decimal_point,
    output reg [3:0] anode
    );

wire [1:0] counter;
reg [3:0] digit;
reg [19:0] clkdiv;	
	 

assign counter = clkdiv[19:18];   always @(*)
    case(counter)
	0: {digit, decimal_point} = {bcd_in[3:0], decimal_points[0]};
	1: {digit, decimal_point} = {bcd_in[7:4], decimal_points[1]};
        2: {digit, decimal_point} = {bcd_in[11:8], decimal_points[2]};
        3: {digit, decimal_point} = {bcd_in[15:12], decimal_points[3]};
     endcase

always @(*)
     case(digit)
	0: a_to_g = 7'b0000001;
	1: a_to_g = 7'b1001111;
	2: a_to_g = 7'b0010010;
	3: a_to_g = 7'b0000110;
	4: a_to_g = 7'b1001100;
	5: a_to_g = 7'b0100100;
	6: a_to_g = 7'b0100000;
	7: a_to_g = 7'b0001111;
	8: a_to_g = 7'b0000000;
	9: a_to_g = 7'b0000100;
	default: a_to_g = 7'b0000001;  endcase
	  
always @(*)
    case(counter)
	0: anode = 4'b1110;
	1: anode = {2'b11,!(| bcd_in[15:4]),1'b1};
	2: anode = {1'b1,!(| bcd_in[15:8]),2'b11};
	3: anode = {!(| bcd_in[15:12]),3'b111};
	default: anode = 4'b1111;  endcase
     
always  @ (posedge clk)
   begin
	clkdiv <= clkdiv + 20'b1;
   end 
	  
endmodule