//925
module abs_sum(
    input [7:0] in,
    output reg [31:0] out
);

    always @(*) begin
        if (in[7] == 1) begin
            out = ~(in) + 1;
        end else begin
            out = in;
        end
    end

endmodule

module top_module(
    input [7:0] in1,
    input [7:0] in2,
    input [7:0] in3,
    input [7:0] in4,
    input sel1,
    input sel2,
    output reg [31:0] out
);

    wire [7:0] selected_input;
    wire [31:0] abs_val1, abs_val2, abs_val3, abs_val4;

    assign selected_input = sel1 & sel2 ? in4 :
                            sel1 ? in3 :
                            sel2 ? in2 :
                            in1;

    abs_sum abs1(.in(selected_input), .out(abs_val1));
    abs_sum abs2(.in(in1), .out(abs_val2));
    abs_sum abs3(.in(in2), .out(abs_val3));
    abs_sum abs4(.in(in3), .out(abs_val4));

    always @(*) begin
        out = abs_val1 + abs_val2 + abs_val3 + abs_val4;
    end

endmodule