//75
module ads62p44_spi(
output reg sdio,
output reg csb,
input rst,
input clk,
output reg spi_ok,
input [2:0] adcmode
);
wire [6:0] lut_index=7'd12;function [15:0] lut_data;
	input [5:0] addr;
	begin
		case(addr)6'd0 :lut_data = {8'h00,6'd0,1'b1,1'b1};6'd1 :lut_data = {8'h10,2'b00,6'd0};6'd2 :lut_data = {8'h11,2'd0,2'd0,2'd0,2'd0};6'd3 :lut_data = {8'h12,2'd0,6'd0};6'd4 :lut_data = {8'h13,3'd0,1'b0,4'd0};6'd5 :lut_data = {8'h14,1'b0,1'b0,1'b0,1'b0,1'b0,3'd0};6'd6 :lut_data = {8'h16,3'd0,1'b0,1'b0,3'b000};6'd7 :lut_data = {8'h17,4'd0,4'b0000};6'd8 :lut_data = {8'h18,8'b0101_0101};6'd9 :lut_data = {8'h19,2'd0,6'b0101_01};6'd10:lut_data = {8'h1a,1'b0,3'b011,4'b0000};6'd11:lut_data = {8'h1b,1'b1,1'b0,6'd0};6'd12:lut_data = {8'h1d,6'd0,2'b11};endcase
	end
endfunction
reg [5:0] addr;
reg [4:0] state;
reg [15:0] dout_reg;
reg [4:0] shift_reg;
reg [2:0] adcmode_reg;
always @ (posedge clk or negedge rst)
if(!rst)
	begin
		csb<=1'b1;
		sdio<=1'b1;
		state<=5'd0;
		addr<=6'd0;
		dout_reg<=16'd0;
		shift_reg<=5'd0;
		spi_ok<=1'b0;
		adcmode_reg<=3'd0;
	end
else
	begin
		case(state)
			5'd0:
				begin
					csb<=1'b1;
					dout_reg<=lut_data(addr);
					state<=5'd1;
				end
			5'd1:
				begin
					if(shift_reg<=5'd15)
						begin
							csb<=1'b0;
							sdio<=dout_reg[15];
							dout_reg<=dout_reg<<1;
							shift_reg<=shift_reg+1'b1;
							state<=5'd1;
						end
					else
						begin
							shift_reg<=5'd0;
							csb<=1'b1;
							sdio<=1'b1;
							if(addr<lut_index)
								begin
									addr<=addr+1'b1;
									state<=5'd0;
								end
							else
								begin
									addr<=6'd0;
									state<=5'd2;
								end
						end
				end
			5'd2:
				begin
					spi_ok<=1'b1;
					state<=5'd3;
				end
			5'd3:
				begin
					if(adcmode_reg!=adcmode)
						begin state<=5'd4;end
					else
						begin state<=5'd3;end
				end
			5'd4:
				begin
					state<=5'd5;adcmode_reg<=adcmode;
				end
			5'd5:
				begin
					csb<=1'b1;dout_reg<={8'h16,3'd0,1'b0,1'b0,adcmode};state<=5'd6;
				end
			5'd6:
				begin
					if(shift_reg<=5'd15)
						begin 
							csb<=1'b0;sdio<=dout_reg[15];dout_reg<=dout_reg<<1;shift_reg<=shift_reg+1'b1;state<=5'd6;
						end
					else 
						begin 
							shift_reg<=5'd0;csb<=1'b1;sdio<=1'b1;state<=5'd3;
						end
				end
		endcase
	end
endmodule