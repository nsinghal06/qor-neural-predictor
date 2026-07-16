//681
module xrs(
	input		clk_i,
	input	[4:0]	ra_i,
	input	[63:0]	rdat_i,
	output	[63:0]	rdat_o,
	input	[3:0]	rmask_i
);
	wire [63:0] q;
	reg [4:0] addr;

	always @(posedge clk_i) addr <= ra_i;
	assign rdat_o = (|addr) ? q : 0;

	ram column3(
		.din(rdat_i[63:48]),
		.addr(ra_i),
		.write_en(rmask_i[3]),
		.clk(clk_i),
		.dout(q[63:48])
	);

	ram column2(
		.din(rdat_i[47:32]),
		.addr(ra_i),
		.write_en(rmask_i[2]),
		.clk(clk_i),
		.dout(q[47:32])
	);

	ram column1(
		.din(rdat_i[31:16]),
		.addr(ra_i),
		.write_en(rmask_i[1]),
		.clk(clk_i),
		.dout(q[31:16])
	);

	ram column0(
		.din(rdat_i[15:0]),
		.addr(ra_i),
		.write_en(rmask_i[0]),
		.clk(clk_i),
		.dout(q[15:0])
	);
endmodule

module ram (din, addr, write_en, clk, dout);
	parameter addr_width = 5;
	parameter data_width = 16;
	input [addr_width-1:0] addr;
	input [data_width-1:0] din;
	input write_en, clk;
	output [data_width-1:0] dout;

	reg [data_width-1:0] dout; reg [data_width-1:0] mem [(1<<addr_width)-1:0];

	always @(posedge clk)
	begin
		if (write_en) mem[(addr)] <= din;
		dout = mem[addr]; end
endmodule