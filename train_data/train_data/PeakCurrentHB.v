//1207
module PeakCurrentHB(clk, cmp, DT, MaxCount, High, Low);

input clk, cmp;
input [7:0] DT, MaxCount;
output reg High, Low;

reg [7:0] Counter = 0;
reg [7:0] DTCount = 0;
reg [7:0] MaxDuty = 0;
reg Flag;

wire [7:0] Counter_Next, DTCount_Next, MaxDuty_Next;
wire High_Next, Low_Next, Flag_Next;

initial begin
  High = 0;
  Low = 1;
end

always @ (posedge(clk))
begin
	Counter <= Counter_Next;
	High <= High_Next;
	Low <= Low_Next;
	Flag <= Flag_Next;
	MaxDuty <= MaxDuty_Next;
end

always @ (negedge(High))
begin
	DTCount <= DTCount_Next;
end

assign Flag_Next = (Counter == 8'b00000000)?0:(cmp || Flag);
assign Counter_Next = (Counter < MaxCount)?(Counter+1):0;
assign High_Next = (Counter >= DT) && (!Flag) && (Counter < MaxDuty);
assign Low_Next = ((Flag) && (Counter > DTCount)) || ((!High) && (Counter > MaxDuty) && (Counter >= DTCount));
assign DTCount_Next = Counter + DT;
assign MaxDuty_Next = (MaxCount >> 1) - 1;

endmodule