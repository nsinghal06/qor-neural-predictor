//1178
module add_sub_shift (
    input clk,
    input reset,
    input [31:0] a,
    input [31:0] b,
    input sub,
    input d,
    output [31:0] out
);

    reg [31:0] shift_reg [2:0];
    reg [1:0] shift_index;
    wire [31:0] shift_out;
    wire [31:0] add_sub_out;
    
    assign shift_out = shift_reg[shift_index];
    
    add_sub add_sub_inst (
        .a(a),
        .b(shift_out),
        .sub(sub),
        .out(add_sub_out)
    );
    
    always @(posedge clk) begin
        if (reset) begin
            shift_reg[0] <= 0;
            shift_reg[1] <= 0;
            shift_reg[2] <= 0;
            shift_index <= 0;
        end else begin
            shift_reg[shift_index] <= d;
            shift_index <= (shift_index == 2) ? 0 : shift_index + 1;
        end
    end
    
    assign out = add_sub_out;
    
endmodule

module add_sub (
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] out
);
    
    assign out = sub ? a - b : a + b;
    
endmodule