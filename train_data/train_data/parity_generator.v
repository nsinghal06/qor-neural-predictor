//939
module parity_generator (
    input clk,
    input reset,
    input [7:0] in,
    output reg parity
);

reg [7:0] data_reg;
reg [7:0] data_reg_1;
reg [7:0] data_reg_2;
reg [7:0] data_reg_3;
reg [7:0] data_reg_4;
reg [7:0] data_reg_5;
reg [7:0] data_reg_6;

wire [7:0] xor_1;
wire [7:0] xor_2;
wire [7:0] xor_3;
wire [7:0] xor_4;
wire [7:0] xor_5;
wire [7:0] xor_6;

wire [7:0] sum_1;
wire [7:0] sum_2;
wire [7:0] sum_3;
wire [7:0] sum_4;
wire [7:0] sum_5;

// Pipeline stage 1
always @(posedge clk, posedge reset) begin
    if (reset) begin
        data_reg <= 8'b0;
    end else begin
        data_reg <= in;
    end
end

// Pipeline stage 2
always @(posedge clk, posedge reset) begin
    if (reset) begin
        data_reg_1 <= 8'b0;
    end else begin
        data_reg_1 <= data_reg;
    end
end

// Pipeline stage 3
always @(posedge clk, posedge reset) begin
    if (reset) begin
        data_reg_2 <= 8'b0;
    end else begin
        data_reg_2 <= data_reg_1;
    end
end

// Pipeline stage 4
always @(posedge clk, posedge reset) begin
    if (reset) begin
        data_reg_3 <= 8'b0;
    end else begin
        data_reg_3 <= data_reg_2;
    end
end

// Pipeline stage 5
always @(posedge clk, posedge reset) begin
    if (reset) begin
        data_reg_4 <= 8'b0;
    end else begin
        data_reg_4 <= data_reg_3;
    end
end

// Pipeline stage 6
always @(posedge clk, posedge reset) begin
    if (reset) begin
        data_reg_5 <= 8'b0;
    end else begin
        data_reg_5 <= data_reg_4;
    end
end

// Pipeline stage 7
always @(posedge clk, posedge reset) begin
    if (reset) begin
        data_reg_6 <= 8'b0;
    end else begin
        data_reg_6 <= data_reg_5;
    end
end

// XOR gates
assign xor_1 = data_reg_1 ^ data_reg_2;
assign xor_2 = data_reg_3 ^ data_reg_4;
assign xor_3 = data_reg_5 ^ data_reg_6;
assign xor_4 = xor_1 ^ xor_2;
assign xor_5 = xor_4 ^ xor_3;

// Full adders
full_adder fa_1 (.a(xor_1[0]), .b(xor_1[1]), .cin(1'b0), .sum(sum_1[0]), .cout(sum_1[1]));
full_adder fa_2 (.a(xor_2[0]), .b(xor_2[1]), .cin(1'b0), .sum(sum_2[0]), .cout(sum_2[1]));
full_adder fa_3 (.a(xor_4[0]), .b(xor_4[1]), .cin(sum_1[1]), .sum(sum_3[0]), .cout(sum_3[1]));
full_adder fa_4 (.a(xor_3[0]), .b(xor_3[1]), .cin(sum_2[1]), .sum(sum_4[0]), .cout(sum_4[1]));
full_adder fa_5 (.a(sum_3[0]), .b(sum_4[0]), .cin(sum_3[1]), .sum(sum_5[0]), .cout(parity));

endmodule

module full_adder (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (b & cin) | (a & cin);

endmodule