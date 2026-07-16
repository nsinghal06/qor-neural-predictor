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