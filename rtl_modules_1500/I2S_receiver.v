//924
module I2S_receiver (
   input 						clk,			// Main Clock
   input          	  		FRM,			// I2S Framing Input
   input       	     		BCK,			// I2S Sample bit clock input
   input    	     	   	DIN,			// I2S Serial audio data input
   output			[15:0]  	out_L,		// Left output
   output			[15:0]  	out_R,		// Right output
	output						ready_L,	// Signal that data is ready to be sent out
	output						ready_R 	// Signal that data is ready to be sent out
);

reg [31:0] shift_reg;	// Shift register to store incoming I2S data
reg [1:0] channel_sel;	// Channel selection (0 for left, 1 for right)
reg [15:0] data_L;		// Data for left channel
reg [15:0] data_R;		// Data for right channel
reg ready_L;		// Ready signal for left channel
reg ready_R;		// Ready signal for right channel

assign out_L = data_L;	// Assign left channel data to output
assign out_R = data_R;	// Assign right channel data to output

always @(posedge BCK) begin
	if (FRM) begin	// If framing signal is high, switch to right channel
		channel_sel <= 1;
	end else begin	// Otherwise, stay on left channel
		channel_sel <= 0;
	end
	
	shift_reg <= {shift_reg[15:0], DIN};	// Shift incoming data into shift register
	
	if (channel_sel == 0) begin	// If on left channel
		ready_L <= 0;
		if (ready_L) begin	// If ready signal is high, store data
			data_L <= shift_reg[31:16];
			ready_L <= 1;	// Set ready signal to low
		end else begin	// Otherwise, check if data is ready
			if (shift_reg[15:0] != 16'h8000) begin	// If data is not 0x8000, set ready signal high
				ready_L <= 1;
			end
		end
	end else begin	// If on right channel
		ready_R <= 0;
		if (ready_R) begin	// If ready signal is high, store data
			data_R <= shift_reg[31:16];
			ready_R <= 1;	// Set ready signal to low
		end else begin	// Otherwise, check if data is ready
			if (shift_reg[15:0] != 16'h8000) begin	// If data is not 0x8000, set ready signal high
				ready_R <= 1;
			end
		end
	end
end

endmodule