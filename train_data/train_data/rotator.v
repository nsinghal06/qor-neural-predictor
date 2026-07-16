//36
module rotator(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

    reg [99:0] shift_reg;
    reg [5:0] shift_amt;

    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data;
        end else if (ena == 2'b00) begin
            shift_reg <= {shift_reg[99], shift_reg[98:1]};
        end else if (ena == 2'b01) begin
            shift_reg <= {shift_reg[98:0], shift_reg[99]};
        end
    end

    always @(*) begin
        if (ena == 2'b00) begin
            shift_amt = 1;
        end else if (ena == 2'b01) begin
            shift_amt = 2;
        end else begin
            shift_amt = 0;
        end
    end

    assign q = {shift_reg[shift_amt-1:0], shift_reg[99:shift_amt]};
endmodule

module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

    rotator rotator_inst(
        .clk(clk),
        .load(load),
        .ena(ena),
        .data(data),
        .q(q)
    );

endmodule