//722
module cross_clock_reader
    #(
        parameter WIDTH = 1,
        parameter DEFAULT = 0
    )
    (
        input clk, input rst,
        input [WIDTH-1:0] in,
        output reg [WIDTH-1:0] out
    );

    reg [WIDTH-1:0] shadow0, shadow1;
    reg [2:0] count;

    always @(posedge clk) begin
        if (rst) begin
            out <= DEFAULT;
            shadow0 <= DEFAULT;
            shadow1 <= DEFAULT;
            count <= 0;
        end
        else if (shadow0 == shadow1) count <= count + 1;
        else count <= 0;
        shadow0 <= in;
        shadow1 <= shadow0;
        if (count == 3'b111) out <= shadow1;
    end

endmodule