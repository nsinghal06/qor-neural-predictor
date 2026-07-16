//910
module adder_16 (input [15:0] in1, input [15:0] in2, input cin, output reg [16:0] res, output reg cout);
  reg [15:0] sum;
  reg [15:0] carry;
  always @* begin
    {carry, sum} = in1 + in2 + cin;
    if (sum[15] == carry[15]) begin
      res = {carry, sum};
      cout = 0;
    end else begin
      res = {~carry, sum + 1'b1};
      cout = 1;
    end
  end
endmodule