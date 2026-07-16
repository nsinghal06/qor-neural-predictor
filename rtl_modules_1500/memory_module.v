//1415
module memory_module
(
    DOBDO,  // Output
    ETH_CLK_OBUF,
    ADDRBWRADDR,
    pwropt
);

output [3:0] DOBDO;
input ETH_CLK_OBUF;
input [12:0] ADDRBWRADDR;
input pwropt;

reg [3:0] memory [0:8191];

// Write data to memory when pwropt is asserted
always @(posedge ETH_CLK_OBUF) begin
    if (pwropt) begin
        memory[ADDRBWRADDR[12:0]] <= DOBDO;
    end
end

// Read data from memory
assign DOBDO = memory[ADDRBWRADDR[12:0]];

endmodule