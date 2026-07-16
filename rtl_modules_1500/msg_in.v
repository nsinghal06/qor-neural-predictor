//1436
module msg_in(
    input clk,
    input rst,
    input start,
    input [31:0] msg_in,
    output reg done,
    output reg [511:0] msg_out
);

reg [4:0] count; 

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        count <= 0;
        done <= 0;
        msg_out <= 0;
    end else if (start && !done) begin 
        if (count < 16) begin
            msg_out <= (msg_out << 32) | msg_in;
            count <= count + 1;
        end
        if (count == 15) begin 
            done <= 1; 
        end
    end
end

endmodule