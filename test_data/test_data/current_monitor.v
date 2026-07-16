//628
module current_monitor (
    input wire clk,
    input wire tick_eI,
    input wire i_measured_eI,
    input wire iSet_change_eI,
    output reg unsafe_eO,
    input wire [7:0] i_I,
    input wire [7:0] iSet_I,
    input wire reset
);

    reg [1:0] state, next_state;
    reg entered, s_wait_alg0_alg_en, s_count_alg0_alg_en, updateThresh_alg_en;
    reg [7:0] i, iSet;
    reg [15:0] v, thresh;

    parameter STATE_s_start = 2'b00;
    parameter STATE_s_wait = 2'b01;
    parameter STATE_s_count = 2'b10;
    parameter STATE_s_over = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_s_start;
            entered <= 1'b0;
            s_wait_alg0_alg_en <= 1'b0;
            s_count_alg0_alg_en <= 1'b0;
            updateThresh_alg_en <= 1'b0;
            unsafe_eO <= 1'b0;
            i <= 0;
            iSet <= 0;
            v <= 0;
            thresh <= 0;
        end else begin
            unsafe_eO <= 1'b0;
            entered <= 1'b0;
            if (i_measured_eI) begin
                i <= i_I;
            end
            if (iSet_change_eI) begin
                iSet <= iSet_I;
            end
            case (state)
                STATE_s_start: begin
                    next_state <= STATE_s_wait;
                    entered <= 1'b1;
                end
                STATE_s_wait: begin
                    if (i > iSet) begin
                        next_state <= STATE_s_count;
                        entered <= 1'b1;
                    end
                end
                STATE_s_count: begin
                    if (i <= iSet) begin
                        next_state <= STATE_s_wait;
                        entered <= 1'b1;
                    end else if (v > thresh) begin
                        next_state <= STATE_s_over;
                        entered <= 1'b1;
                    end else if (tick_eI) begin
                        next_state <= STATE_s_count;
                        entered <= 1'b1;
                    end
                end
                STATE_s_over: begin
                    if (i <= iSet) begin
                        next_state <= STATE_s_wait;
                        entered <= 1'b1;
                    end else if (1'b1) begin
                        next_state <= STATE_s_over;
                        entered <= 1'b1;
                    end
                end
            endcase
            if (entered) begin
                case (state)
                    STATE_s_wait: begin
                        if (s_wait_alg0_alg_en) begin
                            v <= 0;
                        end
                    end
                    STATE_s_count: begin
                        if (s_count_alg0_alg_en) begin
                            v <= v + 1;
                        end
                        if (updateThresh_alg_en) begin
                            if (i > 145) begin
                                thresh <= 5;
                            end else if (i > 100) begin
                                thresh <= 10;
                            end else if (i > 77) begin
                                thresh <= 15;
                            end else if (i > 55) begin
                                thresh <= 30;
                            end else if (i > 32) begin
                                thresh <= 60;
                            end else if (i > 23) begin
                                thresh <= 100;
                            end else if (i > 19) begin
                                thresh <= 150;
                            end else if (i > 14) begin
                                thresh <= 300;
                            end else begin
                                thresh <= 400;
                            end
                        end
                    end
                    STATE_s_over: begin
                        unsafe_eO <= 1'b1;
                    end
                endcase
            end
            state <= next_state;
        end
    end

endmodule