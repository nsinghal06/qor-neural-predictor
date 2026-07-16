//1485
module traffic_light(clock, reset, enable, red, yellow, green);

input clock, reset, enable;
output red, yellow, green;

reg [2:0] state;
reg [4:0] counter;

parameter STATE_RED = 3'b001;
parameter STATE_YELLOW = 3'b010;
parameter STATE_GREEN = 3'b100;

assign red = (state == STATE_RED) ? 1 : 0;
assign yellow = (state == STATE_YELLOW) ? 1 : 0;
assign green = (state == STATE_GREEN) ? 1 : 0;

always @(posedge clock) begin
    if (reset) begin
        state <= STATE_RED;
        counter <= 0;
    end else if (enable) begin
        case (state)
            STATE_RED: begin
                if (counter == 30) begin
                    state <= STATE_YELLOW;
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            STATE_YELLOW: begin
                if (counter == 5) begin
                    state <= STATE_GREEN;
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
            STATE_GREEN: begin
                if (counter == 30) begin
                    state <= STATE_YELLOW;
                    counter <= 0;
                end else begin
                    counter <= counter + 1;
                end
            end
        endcase
    end
end

endmodule