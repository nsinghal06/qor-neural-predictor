//871
module dffpipe (
    input clk,
    input din,
    output reg dout,
    input reset_n
);

    reg wire_dffpipe_q;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            wire_dffpipe_q <= 1'b0;
        end else begin
            wire_dffpipe_q <= din;
        end
    end

    always @*
    begin
        dout <= wire_dffpipe_q;
    end

endmodule