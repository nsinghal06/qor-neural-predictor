//300
module Debounce_Circuit (
    input CLK_IN,
    input reset,
    input enb,
    input In,
    output reg Out
);

    wire [7:0] Debounce_Count_out1;
    wire Count_Up_Down_out1;

    assign Debounce_Count_out1 = 8'd25; // set debounce count to 25

    Count_Up_Down u_Count_Up_Down (
        .CLK_IN(CLK_IN),
        .reset(reset),
        .enb(enb),
        .In(In),
        .count_debounce(Debounce_Count_out1),
        .y(Count_Up_Down_out1)
    );

    always @(posedge CLK_IN) begin
        if (reset) begin
            Out <= 0;
        end else if (enb) begin
            if (Count_Up_Down_out1) begin
                Out <= 1;
            end else begin
                Out <= 0;
            end
        end
    end

endmodule

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