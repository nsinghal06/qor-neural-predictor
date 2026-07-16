module edge_detection (
    input a,
    input clk,
    output reg rising_edge,
    output reg falling_edge
);
    parameter IDLE = 2'b00, RISING = 2'b01, FALLING = 2'b10;
    reg [1:0] state, next_state;
    
    always @(posedge clk) begin
        state <= next_state;
    end
    
    always @(*) begin
        case (state)
            IDLE: begin
                if (a) begin
                    next_state = RISING;
                end else begin
                    next_state = IDLE;
                end
            end
            RISING: begin
                if (a) begin
                    next_state = RISING;
                end else begin
                    next_state = FALLING;
                end
            end
            FALLING: begin
                if (a) begin
                    next_state = RISING;
                end else begin
                    next_state = FALLING;
                end
            end
        endcase
    end
    
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                rising_edge <= 1'b0;
                falling_edge <= 1'b0;
            end
            RISING: begin
                rising_edge <= 1'b1;
                falling_edge <= 1'b0;
            end
            FALLING: begin
                rising_edge <= 1'b0;
                falling_edge <= 1'b1;
            end
        endcase
    end
endmodule