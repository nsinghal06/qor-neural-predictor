//884
module myModule (
    input clk,
    input [1:0] in,
    output [1:0] out,
    output reg stop
);

reg [63:0] result;
wire [63:0] expected_sum = 64'hbb2d9709592f64bd;
reg [63:0] crc;
reg [63:0] sum;
reg [6:0] cyc;

assign out = result[1:0];

always @(posedge clk) begin
    cyc <= cyc + 1;
    crc <= {crc[62:0], crc[63]^crc[2]^crc[0]};
    sum <= result ^ {sum[62:0],sum[63]^sum[2]^sum[0]};
    
    if (cyc == 0) begin
        crc <= 64'h5aef0c8d_d70a4497;
    end
    else if (cyc < 10) begin
        sum <= 64'h0;
    end
    else if (cyc < 90) begin
        result <= {62'h0, in};
    end
    else if (cyc == 99) begin
        if (crc !== 64'hc77bb9b3784ea091) stop <= 1'b1;
        else if (sum !== expected_sum) stop <= 1'b1;
        else begin 
            stop <= 1'b0;
        end 
    end
end

endmodule