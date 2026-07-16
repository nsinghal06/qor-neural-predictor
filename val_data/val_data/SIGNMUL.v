module SIGNMUL (dataa, datab, result);

	input	signed	[31:0]	dataa,datab;
	output	signed	[63:0]	result;
	
	assign result = dataa * datab;
	
endmodule