//1059
module pipelined_addsub (
    input [31:0] a,
    input [31:0] b,
    input mode,
    output reg [31:0] out,
    output reg flag,
    input clk
);

reg [31:0] sum;
reg [31:0] diff;
reg [31:0] a_reg, b_reg;
reg mode_reg;
reg diff_reg, sum_reg;

// Register input values
always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
    mode_reg <= mode;
end

// Calculate sum and difference
always @(*) begin
    if (mode_reg == 1'b0) begin
        sum = a_reg + b_reg;
        diff = a_reg - b_reg;
    end else begin
        sum = a_reg - b_reg;
        diff = a_reg + b_reg;
    end
end

// Calculate flag
always @(*) begin
    if (mode_reg == 1'b0) begin
        if (sum[31] != a_reg[31] && sum[31] != b_reg[31]) begin
            flag = 1'b1;
        end else begin
            flag = 1'b0;
        end
    end else begin
        if (diff[31] != a_reg[31] && diff[31] != b_reg[31]) begin
            flag = 1'b1;
        end else begin
            flag = 1'b0;
        end
    end
end

// Register sum and difference
always @(posedge clk) begin
    sum_reg <= sum;
    diff_reg <= diff;
end

// Output sum or difference based on mode
always @(posedge clk) begin
    if (mode_reg == 1'b0) begin
        out <= sum_reg;
    end else begin
        out <= diff_reg;
    end
end

endmodule