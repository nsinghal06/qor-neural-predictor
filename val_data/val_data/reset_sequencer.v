//497
module reset_sequencer (
    input clk,
    input reset,
    input rx_locked,
    input pll_areset,
    input rx_reset,
    input rx_cda_reset,
    output reg rx_channel_data_align,
    output reg pll_areset_out,
    output reg rx_reset_out,
    output reg rx_cda_reset_out
    );

    reg [2:0] state;
    reg [2:0] nextstate;
    reg [2:0] pulse_count;
    reg rx_locked_sync_d1;
    reg rx_locked_sync_d2;
    reg rx_locked_sync_d3;
    reg rx_locked_stable;

    parameter [2:0] stm_idle = 3'b000;
    parameter [2:0] stm_pll_areset = 3'b001;
    parameter [2:0] stm_rx_reset = 3'b010;
    parameter [2:0] stm_rx_cda_reset = 3'b011;
    parameter [2:0] stm_word_alignment = 3'b100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= stm_pll_areset;
        end
        else begin
            state <= nextstate;
        end
    end

    always @(*) begin
        case (state)
            stm_idle: begin
                if (reset) begin
                    nextstate = stm_pll_areset;
                end
                else begin
                    nextstate = stm_idle;
                end
            end
            stm_pll_areset: begin
                nextstate = stm_rx_reset;
            end
            stm_rx_reset: begin
                if (!rx_locked_stable) begin
                    nextstate = stm_rx_reset;
                end
                else begin
                    nextstate = stm_rx_cda_reset;
                end
            end
            stm_rx_cda_reset: begin
                nextstate = stm_word_alignment;
            end
            stm_word_alignment: begin
                if (pulse_count == 3'b100) begin
                    nextstate = stm_idle;
                end
                else begin
                    nextstate = stm_word_alignment;
                end
            end
            default: begin
                nextstate = stm_idle;
            end
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rx_locked_sync_d1 <= 1'b0;
            rx_locked_sync_d2 <= 1'b0;
            rx_locked_sync_d3 <= 1'b0;
            rx_locked_stable <= 1'b0;
            pll_areset_out <= 1'b1;
            rx_reset_out <= 1'b1;
            rx_cda_reset_out <= 1'b0;
            rx_channel_data_align <= 1'b0;
            pulse_count <= 3'b000;
        end
        else begin
            rx_locked_sync_d1 <= rx_locked_sync_d2;
            rx_locked_sync_d2 <= rx_locked_sync_d3;
            rx_locked_sync_d3 <= rx_locked;
            rx_locked_stable <= rx_locked_sync_d1 & rx_locked_sync_d2 & rx_locked_sync_d3 & rx_locked;
            case (nextstate)
                stm_idle: begin
                    pll_areset_out <= 1'b0;
                    rx_reset_out <= 1'b0;
                    rx_cda_reset_out <= 1'b0;
                    rx_channel_data_align <= 1'b0;
                    pulse_count <= 3'b000;
                end
                stm_pll_areset: begin
                    pll_areset_out <= 1'b1;
                    rx_reset_out <= 1'b1;
                    rx_cda_reset_out <= 1'b0;
                    rx_channel_data_align <= 1'b0;
                    pulse_count <= 3'b000;
                end
                stm_rx_reset: begin
                    pll_areset_out <= 1'b0;
                    rx_reset_out <= 1'b0;
                    rx_cda_reset_out <= 1'b0;
                    rx_channel_data_align <= 1'b0;
                    pulse_count <= 3'b000;
                end
                stm_rx_cda_reset: begin
                    pll_areset_out <= 1'b0;
                    rx_reset_out <= 1'b0;
                    rx_cda_reset_out <= 1'b1;
                    rx_channel_data_align <= 1'b0;
                    pulse_count <= 3'b000;
                end
                stm_word_alignment: begin
                    pll_areset_out <= 1'b0;
                    rx_reset_out <= 1'b0;
                    rx_cda_reset_out <= 1'b0;
                    rx_channel_data_align <= ~rx_channel_data_align;
                    pulse_count <= pulse_count + 1'b1;
                end
                default: begin
                    pll_areset_out <= 1'b0;
                    rx_reset_out <= 1'b0;
                    rx_cda_reset_out <= 1'b0;
                    rx_channel_data_align <= 1'b0;
                    pulse_count <= 3'b000;
                end
            endcase
        end
    end

endmodule