//802
module four_digit_seven_seg#(
    parameter COUNTER_WIDTH = 18
)(
    input wire clk_in,
    input wire [15:0] data_in,
    input wire [3:0] dots_in,
    output wire [7:0] segs_out,
    output wire [3:0] anodes_out
);

    reg [COUNTER_WIDTH-1:0] count = 0;
    wire [COUNTER_WIDTH-1:0] count_next;
    wire [1:0] anodeSelect;
    wire [3:0] nibble;
    wire [6:0] segs;
    wire dot;

    always @(posedge clk_in) begin
        count <= count_next;
    end

    assign count_next = count + 1'b1;
    assign anodeSelect = count[COUNTER_WIDTH-1:COUNTER_WIDTH-2];

    assign anodes_out = (anodeSelect == 2'b00) ? 4'b1110 :
                       (anodeSelect == 2'b01) ? 4'b1101 :
                       (anodeSelect == 2'b10) ? 4'b1011 :
                       4'b0111;

    assign dot = (anodeSelect == 2'b00) ? ~dots_in[0] :
                 (anodeSelect == 2'b01) ? ~dots_in[1] :
                 (anodeSelect == 2'b10) ? ~dots_in[2] :
                 ~dots_in[3];

    assign nibble = (anodeSelect == 2'b00) ? data_in[15:12] :
                    (anodeSelect == 2'b01) ? data_in[11:8] :
                    (anodeSelect == 2'b10) ? data_in[7:4] :
                    data_in[3:0];

    assign segs = (nibble == 4'b0000) ? 7'b1000000 :
                 (nibble == 4'b0001) ? 7'b1111001 :
                 (nibble == 4'b0010) ? 7'b0100100 :
                 (nibble == 4'b0011) ? 7'b0110000 :
                 (nibble == 4'b0100) ? 7'b0011001 :
                 (nibble == 4'b0101) ? 7'b0010010 :
                 (nibble == 4'b0110) ? 7'b0000010 :
                 (nibble == 4'b0111) ? 7'b1111000 :
                 (nibble == 4'b1000) ? 7'b0000000 :
                 (nibble == 4'b1001) ? 7'b0010000 :
                 (nibble == 4'b1010) ? 7'b0001000 :
                 (nibble == 4'b1011) ? 7'b0000011 :
                 (nibble == 4'b1100) ? 7'b1000110 :
                 (nibble == 4'b1101) ? 7'b0100001 :
                 (nibble == 4'b1110) ? 7'b0000110 :
                 7'b0001110;

    assign segs_out = {dot, segs};

endmodule