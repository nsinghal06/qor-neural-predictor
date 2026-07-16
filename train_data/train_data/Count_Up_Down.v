module Count_Up_Down (
    input CLK_IN,
    input reset,
    input enb,
    input In,
    input [7:0] count_debounce,
    output reg y
);

    reg [7:0] count;

    always @(posedge CLK_IN or posedge reset) begin
        if (reset) begin
            count <= 0;
        end else if (enb) begin
            if (count < count_debounce) begin
                count <= count + 1;
            end else begin
                count <= 0;
            end
        end
    end

    always @* begin
        y = (count == count_debounce);
    end

endmodule