//1374
module RAM512x16_1R1W (
    input clock,
    input [15:0] data,
    input [8:0] rdaddress,
    input [8:0] wraddress,
    input wren,
    output reg [15:0] q
);

    reg [15:0] q_reg;

    always @ (posedge clock) begin
        if (wren) begin
            q_reg[wraddress] <= data;
        end
        q <= q_reg[rdaddress];
    end

endmodule