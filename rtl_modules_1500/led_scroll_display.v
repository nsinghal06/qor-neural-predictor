//1183
module led_scroll_display (
    input clk,
    input reset,
    input load,
    input [1:0] ena,
    input [63:0] data,
    output reg [7:0] led_row,
    output reg [7:0] led_col
);

reg [63:0] shift_reg;
reg [3:0] counter;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 64'b0;
        counter <= 4'b0;
    end else begin
        if (load) begin
            shift_reg <= data;
        end else begin
            case (ena)
                2'b00: shift_reg <= {shift_reg[62:0], shift_reg[63]};
                2'b01: shift_reg <= {shift_reg[63], shift_reg[1:0]};
                2'b10: shift_reg <= {shift_reg[59:0], shift_reg[63:60]};
                2'b11: shift_reg <= {shift_reg[63:4], shift_reg[3:0]};
            endcase
        end
        
        if (counter == 4'b1111) begin
            counter <= 4'b0;
        end else begin
            counter <= counter + 1;
        end
    end
end

always @(*) begin
    led_row = shift_reg[7:0] | counter;
    led_col = shift_reg[15:8] | counter;
end

endmodule