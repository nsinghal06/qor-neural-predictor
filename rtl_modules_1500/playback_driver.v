//687
module playback_driver (
    input clk,
    input rst,
    input [31:0] data_in,
    output reg [31:0] data_out
);

reg [31:0] playback_data;
reg [31:0] playback_ptr;

`ifdef DUMP_ON
    initial begin
        if($test$plusargs("dump"))
            $fsdbDumpvars(0, playback_driver);
    end
`endif

always @(posedge clk) begin
    if (rst) begin
        playback_ptr <= 0;
        data_out <= 0;
    end else begin
        playback_data <= data_in[playback_ptr];
        data_out <= playback_data;
        playback_ptr <= playback_ptr + 1;
    end
end

endmodule