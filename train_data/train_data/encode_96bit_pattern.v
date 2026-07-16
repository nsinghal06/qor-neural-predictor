//1457
module encode_96bit_pattern (edgechoice,enable,d,CLK200,CLK400,code,tdc_hit,scaler_hit);

	genvar i;

	parameter encodedbits = 9; input wire CLK200;
	input wire CLK400;

	input wire [95:0] d;

	input wire edgechoice;
	input wire enable;
	
	output reg [encodedbits-1:0] code; 
	output reg tdc_hit;
	output reg scaler_hit;

	generate	
		for (i=0; i < 24; i=i+1) begin : STAGE0 	reg [3:0] pattern;
			
			always@(posedge CLK400)
			begin
				if (edgechoice == 1'b0) pattern <= d[4*i+3:4*i+0];
				                   else pattern <= ~d[4*i+3:4*i+0];
			end
			
		end 
	endgenerate	


	generate	
		for (i=0; i < 24; i=i+1) begin : STAGE1 	reg [1:0] addr;
			reg b1111;
			reg b0000;
						
			always@(posedge CLK400)
			begin
			
					if (STAGE0[i].pattern == 4'b1111) b1111 <= 1'b1; else b1111 <= 1'b0;
					if (STAGE0[i].pattern == 4'b0000) b0000 <= 1'b1; else b0000 <= 1'b0;

					case (STAGE0[i].pattern)

						4'b1111: begin addr <= 2'b11; end 
						4'b1110: begin addr <= 2'b11; end 
						4'b1101: begin addr <= 2'b11; end 
						4'b1100: begin addr <= 2'b11; end 
						4'b1011: begin addr <= 2'b11; end 
						4'b1010: begin addr <= 2'b11; end 
						4'b1001: begin addr <= 2'b11; end 
						4'b1000: begin addr <= 2'b11; end 

						4'b0111: begin addr <= 2'b10; end 
						4'b0110: begin addr <= 2'b10; end 
						4'b0101: begin addr <= 2'b10; end 
						4'b0100: begin addr <= 2'b10; end 

						4'b0011: begin addr <= 2'b01; end 
						4'b0010: begin addr <= 2'b01; end 

						4'b0001: begin addr <= 2'b00; end 

						4'b0000: begin addr <= 2'b00; end 

					endcase
					
			end 
			
		end 
	endgenerate	



	generate	
		for (i=0; i < 21; i=i+1) begin : STAGE2 	reg [1:0] addr;
			reg valid;

			always@(posedge CLK400)
			begin
					
				addr <= STAGE1[i+2].addr;
				if (STAGE1[i+3].b0000 == 1'b1 && STAGE1[i+2].b0000 == 1'b0 && STAGE1[i+1].b0000 == 1'b0 && STAGE1[i].b1111 == 1'b1) 
					valid <= 1'b1;
				else 
					valid <= 1'b0;

			end
			
		end
	endgenerate	



	generate	
		for (i=0; i < 11; i=i+1) begin : STAGE3  reg valid;
			reg [2:0] addr;

			if (i==10) begin

					always@(posedge CLK400)
					begin	
						valid <= STAGE2[20].valid;
						addr <= {1'b0,STAGE2[20].addr}; 
					end

			end else begin
			
				always@(posedge CLK400)
				begin	
					
					valid <= STAGE2[2*i+1].valid || STAGE2[2*i+0].valid;
					if (STAGE2[2*i+1].valid == 1'b1) addr <= {1'b1,STAGE2[2*i+1].addr}; 
					                            else addr <= {1'b0,STAGE2[2*i+0].addr}; 

				end
			
			end
	
		end
	endgenerate	



	generate	
		for (i=0; i < 6; i=i+1) begin : STAGE4  reg valid;
			reg [3:0] addr;
			
			if (i==5) begin

					always@(posedge CLK400)
					begin	
						valid <= STAGE3[10].valid;
						addr <= {1'b0,STAGE3[10].addr}; 
					end

			end else begin
			
					always@(posedge CLK400)
					begin	
						
						valid <= STAGE3[2*i+1].valid || STAGE3[2*i+0].valid;
						if (STAGE3[2*i+1].valid == 1'b1) addr <= {1'b1,STAGE3[2*i+1].addr}; 
						                            else addr <= {1'b0,STAGE3[2*i+0].addr}; 

					end

			end
			
		end
	endgenerate	



	generate	
		for (i=0; i < 3; i=i+1) begin : STAGE5  reg valid;
			reg [4:0] addr;
			always@(posedge CLK400)
			begin	
													 
				valid <= STAGE4[2*i+1].valid || STAGE4[2*i+0].valid;
				if (STAGE4[2*i+1].valid == 1'b1) addr <= {1'b1,STAGE4[2*i+1].addr}; 
				                            else addr <= {1'b0,STAGE4[2*i+0].addr}; 

			end
	
		end
	endgenerate	
	
	
	
	reg [4:0] addr_2;
	reg [4:0] addr_1;
	reg [4:0] addr_0;

	reg [6:0] exclusive_addr_2;
	reg [6:0] exclusive_addr_1;
	reg [6:0] exclusive_addr_0;
	
	reg [2:0] hitmap;
	reg [1:0] lowhit;
	reg hit;
	
	reg hit_2A;
	reg hit_2B;
	reg [6:0] addr_2A;
	reg [6:0] addr_2B;

	reg Transition400_hit_A;
	reg Transition400_hit_B;
	reg [6:0] Transition400_addr_A;
	reg [6:0] Transition400_addr_B;

	always@(posedge CLK400)
	begin
		
		if (STAGE5[2].valid == 1'b1 && lowhit[1] == 1'b0) begin hitmap <= 3'b110; lowhit <= 2'b00; end else
		if (STAGE5[1].valid == 1'b1 && lowhit[0] == 1'b0) begin hitmap <= 3'b101; lowhit <= 2'b10; end else
		if (STAGE5[0].valid == 1'b1)                      begin hitmap <= 3'b100; lowhit <= 2'b11; end else
		                                                  begin hitmap <= 3'b000; lowhit <= 2'b00; end

		addr_2 <= STAGE5[2].addr;
		addr_1 <= STAGE5[1].addr;
		addr_0 <= STAGE5[0].addr;

		if (hitmap == 3'b110) exclusive_addr_2 <= {2'b10,addr_2}; else exclusive_addr_2 <= 0;
		if (hitmap == 3'b101) exclusive_addr_1 <= {2'b01,addr_1}; else exclusive_addr_1 <= 0;
		if (hitmap == 3'b100) exclusive_addr_0 <= {2'b00,addr_0}; else exclusive_addr_0 <= 0;
		hit <= hitmap[2];
		
		hit_2A <= hit;
		addr_2A <= {exclusive_addr_2 | exclusive_addr_1 | exclusive_addr_0};

		hit_2B <= hit_2A;
		addr_2B <= addr_2A;
	
		Transition400_hit_A <= hit_2A;
		Transition400_hit_B <= hit_2B;
		Transition400_addr_A <= addr_2A;
		Transition400_addr_B <= addr_2B;

	end


	reg Transition200_hit_A;
	reg Transition200_hit_B;
	reg [6:0] Transition200_addr_A;
	reg [6:0] Transition200_addr_B;
	
	always@(posedge CLK200)
	begin

		Transition200_hit_A <= Transition400_hit_A;
		Transition200_hit_B <= Transition400_hit_B;
		Transition200_addr_A <= Transition400_addr_A;
		Transition200_addr_B <= Transition400_addr_B;
			
		if (Transition200_hit_B == 1'b1) begin
			scaler_hit <= Transition200_hit_B;
			tdc_hit <= Transition200_hit_B & enable;
			code <= {Transition200_hit_B & enable,1'b1,Transition200_addr_B};
		end else begin
			scaler_hit <= Transition200_hit_A;
			tdc_hit <= Transition200_hit_A & enable;
			code <= {Transition200_hit_A & enable,1'b0,Transition200_addr_A};
		end
	end

endmodule