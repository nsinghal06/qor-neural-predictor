//985
module qmults#(
	parameter Q = 15,
	parameter N = 32
	)
	(
	input 	[N-1:0]  i_multiplicand,
	input 	[N-1:0]	i_multiplier,
	input 	i_start,
	input 	i_clk,
	output 	[N-1:0] o_result_out,
	output 	o_complete,
	output	o_overflow
	);

	reg [2*N-2:0]	reg_working_result;		reg [2*N-2:0]	reg_multiplier_temp;		reg [N-1:0]		reg_multiplicand_temp;	reg [N-1:0] 			reg_count; 		reg					reg_done;		reg					reg_sign;		reg					reg_overflow;	initial reg_done = 1'b1;			initial reg_overflow = 1'b0;		initial reg_sign = 1'b0;			assign o_result_out[N-2:0] = reg_working_result[N-2+Q:Q];	assign o_result_out[N-1] = reg_sign;								assign o_complete = reg_done;											assign o_overflow = reg_overflow;									always @( posedge i_clk ) begin
		if( reg_done && i_start ) begin										reg_done <= 1'b0;														reg_count <= 0;														reg_working_result <= 0;											reg_multiplier_temp <= 0;											reg_multiplicand_temp <= 0;										reg_overflow <= 1'b0;												reg_multiplicand_temp <= i_multiplicand[N-2:0];				reg_multiplier_temp <= i_multiplier[N-2:0];					reg_sign <= i_multiplicand[N-1] ^ i_multiplier[N-1];		end 

		else if (!reg_done) begin
			if (reg_multiplicand_temp[reg_count] == 1'b1)								reg_working_result <= reg_working_result + reg_multiplier_temp;	reg_multiplier_temp <= reg_multiplier_temp << 1;						reg_count <= reg_count + 1;													if(reg_count == N) begin
				reg_done <= 1'b1;										if (reg_working_result[2*N-2:N-1+Q] > 0)			reg_overflow <= 1'b1;
end
			end
		end
endmodule