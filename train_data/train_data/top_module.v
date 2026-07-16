//1499
module top_module( 
    input [15:0] in,
    input [2:0] sel,
    output [7:0] out );
    
    wire [1:0] mux0_out, mux1_out, mux2_out, mux3_out;
    wire [7:0] adder_out;
    
    // 2-to-1 multiplexers
    mux2to1 mux0(.in0(in[1:0]), .in1(in[3:2]), .sel(sel[1]), .out(mux0_out));
    mux2to1 mux1(.in0(in[5:4]), .in1(in[7:6]), .sel(sel[1]), .out(mux1_out));
    mux2to1 mux2(.in0(in[9:8]), .in1(in[11:10]), .sel(sel[1]), .out(mux2_out));
    mux2to1 mux3(.in0(in[13:12]), .in1(in[15:14]), .sel(sel[1]), .out(mux3_out));
    
    // Additive functional module
    add add(.in0(mux0_out), .in1(mux1_out), .in2(mux2_out), .in3(mux3_out), .out(adder_out));
    
    // Output
    assign out = adder_out;
    
endmodule

module
module mux2to1(
    input [1:0] in0,
    input [1:0] in1,
    input sel,
    output [1:0] out
    );
    
    assign out = (sel == 0) ? in0 : in1;
    
endmodule

module
module add(
    input [1:0] in0,
    input [1:0] in1,
    input [1:0] in2,
    input [1:0] in3,
    output [7:0] out
    );
    
    assign out = {4'b0, in3, in2, in1, in0} + 8'b0;
    
endmodule