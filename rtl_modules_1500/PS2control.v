//1384
module PS2control(clk, data, outclk, command, attention, keys);

input clk;
input data;
output outclk;
output command;
output attention;
output [7:0] keys;
reg outclk;
reg command;
reg attention;
reg [7:0] keys;

reg [3:0] packetstate;
reg [3:0] gotostate;
reg [3:0] bytecounter;
reg [3:0] bitcounter;
reg [10:0] waitcounter;

reg [7:0] commandshift;

reg [7:0] datashift; initial begin
	packetstate = 4'b1111;
	gotostate   = 4'b0001;
	bytecounter = 5'b00000; bitcounter =  4'b0000;
	waitcounter = 0;
end

always @ (posedge outclk) begin
	datashift = {data, datashift[7:1]};
end

always @ (posedge clk) begin
	case (packetstate)
	
		4'b1111: begin waitcounter = waitcounter + 1;
			if (waitcounter < 2000) begin
				attention = 1; command = 1;  bitcounter = 0;
			end else begin
				waitcounter = 0;
				packetstate = gotostate;
				attention = 0;
			end
		end
		
		4'b1110: begin bitcounter = bitcounter + 1;
			if (bitcounter > 13) begin
				bitcounter = 0;
				packetstate = gotostate; end
		end
		
		4'b0000: begin outclk = ~outclk; command = commandshift[bitcounter];
			bitcounter = bitcounter + outclk;
			if (bitcounter == 8) begin
				packetstate = 4'b1110; bitcounter = 0;
			end
		end
		
		4'b0001: begin bytecounter = bytecounter + 1; packetstate = 4'b0000; case (bytecounter)
				5'b00001: commandshift = 8'h01; 5'b00010: commandshift = 8'h43; 5'b00011: commandshift = 8'h00; 5'b00100: commandshift = 8'h01; 5'b00101: commandshift = 8'h00; 5'b00110: begin
					packetstate = 4'b1111;
					gotostate   = 4'b0010; bytecounter = 5'b00000;
				end
			endcase
			end
		
		4'b0010: begin
			bytecounter = bytecounter + 1; gotostate = 4'b0010;
			packetstate = 4'b0000; case (bytecounter)
				5'b00001: commandshift = 8'h01; 5'b00010: commandshift = 8'h44; 5'b00011: commandshift = 8'h00; 5'b00100: commandshift = 8'h01; 5'b00101: commandshift = 8'h03; 5'b00110: commandshift = 8'h00; 5'b00111: commandshift = 8'h00; 5'b01000: commandshift = 8'h00; 5'b01001: commandshift = 8'h00; 5'b01010: begin packetstate = 4'b1111;
					gotostate   = 4'b0011;
					bytecounter = 5'b00000;
				end
			endcase
			end
		
		4'b0011: begin
			bytecounter = bytecounter + 1; gotostate = 4'b0011;
			packetstate = 4'b0000; case (bytecounter)
				5'b00001: commandshift = 8'h01; 5'b00010: commandshift = 8'h43; 5'b00011: commandshift = 8'h00; 5'b00100: commandshift = 8'h00; 5'b00101: commandshift = 8'h5A; 5'b00110: commandshift = 8'h5A; 5'b00111: commandshift = 8'h5A; 5'b01000: commandshift = 8'h5A; 5'b01001: commandshift = 8'h5A; 5'b01010: begin packetstate = 4'b1111;
					gotostate   = 4'b0100;
					bytecounter = 5'b00000;
				end
			endcase
			end
		
		4'b0100: begin
			bytecounter = bytecounter + 1; packetstate = 4'b0000; gotostate = 4'b0100;
			case (bytecounter)
				5'b00001: commandshift = 8'h01; 5'b00010: commandshift = 8'h42; 5'b00011: commandshift = 8'h00; 5'b00100: commandshift = 8'h00; 5'b00101: begin
					commandshift = 8'h00; keys[0] = ~datashift[0];						keys[1] = ~datashift[3];						keys[2] = ~datashift[4] | ~datashift[6];	end
				5'b00110: begin
					commandshift = 8'h00; keys[3] = ~datashift[7];						keys[4] = ~datashift[6];						keys[5] = ~datashift[4];						keys[6] = ~datashift[5];						keys[7] = ~datashift[1];						end
				5'b00111: begin
					commandshift = 8'h00; end					
				5'b01000: begin
					commandshift = 8'h00; end
				5'b01001: begin
					commandshift = 8'h00; end
				5'b01010: begin packetstate = 4'b1111;
					gotostate   = 4'b0100;
					bytecounter = 5'b00000;
				end					
			endcase
			end
		
		endcase
	
end


endmodule