module adder_tree_branch(a,b,sum);
	parameter EXTRA_BITS = 0;

	input [`ADDER_WIDTH+EXTRA_BITS-1:0] a;
	input [`ADDER_WIDTH+EXTRA_BITS-1:0] b;
	output [`ADDER_WIDTH+EXTRA_BITS:0] sum;

	assign sum = a + b;
endmodule