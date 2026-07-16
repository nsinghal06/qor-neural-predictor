//1211
module my_dff (
    input clk,
    input d,
    output reg q
);

always @(posedge clk)
    q <= d;

endmodule

module top_module (
    input clk,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    input [2:0] sel,
    output [3:0] q
);

wire [3:0] mux_out;
wire [2:0] shift_reg_out;
wire [3:0] func_out;

my_dff dff0(clk, sel[0], shift_reg_out[0]);
my_dff dff1(clk, shift_reg_out[0], shift_reg_out[1]);
my_dff dff2(clk, shift_reg_out[1], shift_reg_out[2]);

assign mux_out = (sel == 0) ? data0 :
                 (sel == 1) ? data1 :
                 (sel == 2) ? data2 :
                 (sel == 3) ? data3 :
                 (sel == 4) ? data4 :
                 (sel == 5) ? data5 :
                 (sel > 5) ? {data5[3], data5[2], data5[1], data5[0]} : 4'b0;

assign func_out = mux_out | shift_reg_out;

assign q = func_out;

endmodule