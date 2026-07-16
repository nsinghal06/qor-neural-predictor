//1053
module instructionmemory(output [31:0] data,input [6:0] addr,input clk);
reg [31:0] data;
reg [7:0] memdata [511:0];

initial 
	begin
	memdata[0]  = 8'b10001101;			memdata[1]  = 8'b10100001;
	memdata[2]  = 8'b00000000;
	memdata[3]  = 8'b00000000;
	
	memdata[4]  = 8'b10001101;			memdata[5]  = 8'b10100010;
	memdata[6]  = 8'b00000000;
	memdata[7]  = 8'b00000001;
	
	memdata[8]  = 8'b00000000;			memdata[9]  = 8'b00100010;
	memdata[10] = 8'b00011000;
	memdata[11] = 8'b00100000;
	
	memdata[12] = 8'b10001101;			memdata[13] = 8'b10100100;
	memdata[14] = 8'b00000000;
	memdata[15] = 8'b00000010;
	
	memdata[16] = 8'b00000000;			memdata[17] = 8'b01100100;
	memdata[18] = 8'b00101000;
	memdata[19] = 8'b00100010;
	
	memdata[20] = 8'b10001101;			memdata[21] = 8'b10100110;
	memdata[22] = 8'b00000000;
	memdata[23] = 8'b00000011;
	
	memdata[24] = 8'b00000000;			memdata[25] = 8'b10100110;
	memdata[26] = 8'b00111000;
	memdata[27] = 8'b00100101;
	
	memdata[28] = 8'b10001101;			memdata[29] = 8'b10101000;
	memdata[30] = 8'b00000000;
	memdata[31] = 8'b00000100;
	
	memdata[32] = 8'b00000000;			memdata[33] = 8'b11101000;
	memdata[34] = 8'b01001000;
	memdata[35] = 8'b00100100;

	memdata[36] = 8'b10101101;          memdata[37] = 8'b10101001;
	memdata[38] = 8'b00000000;
	memdata[39] = 8'b00000111;

	memdata[40] = 8'b00010001;         memdata[41] = 8'b10101101;
	memdata[42] = 8'b11111111;
	memdata[43] = 8'b11111000;

	end

always @(negedge clk)
	begin
		data = { memdata[addr] , memdata[addr+1] , memdata[addr+2] , memdata[addr+3] };
	end
endmodule