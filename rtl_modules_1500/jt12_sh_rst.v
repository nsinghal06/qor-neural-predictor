//533
module jt12_sh_rst #(parameter width=5, stages=32, rstval=1'b0 )
(
	input					rst,	
	input 					clk,
	input					clk_en ,
	input		[width-1:0]	din,
   	output		[width-1:0]	drop
);

reg [stages-1:0] bits[width-1:0];

genvar i;
integer k;
generate
initial
	for (k=0; k < width; k=k+1) begin
		bits[k] = { stages{rstval}};
	end
endgenerate

generate
	for (i=0; i < width; i=i+1) begin: bit_shifter
		always @(posedge clk, posedge rst) 
			if( rst ) begin
				bits[i] <= {stages{rstval}};
			end else if(clk_en) begin
				bits[i] <= {bits[i][stages-2:0], din[i]};
			end
		assign drop[i] = bits[i][stages-1];
	end
endgenerate

endmodule