//834
module r_RX_BUF_OBJ1_BYTE_0(output reg [7:0] reg_0x34, input wire reset, input wire wenb, input wire [7:0] in_data, input wire clk);
	always@(posedge clk)
	begin
		if(reset==0) begin
			if(wenb==0)
				reg_0x34<=in_data;
			else
				reg_0x34<=reg_0x34;
		end
		else
			reg_0x34<=8'h00;
	end
endmodule