//180
module neopixels(
    input         CLOCK_50,
    input  [1:0]  KEY,
    output        data
);


    reg r_data;
    reg [3:0] state_reg;
    reg [3:0] state_set = 4'b0;
    
    reg [7:0] timer_0 = 7'b0;
    reg [7:0] timer_0_compare = 7'd40; reg timer_0_run = 1'b0;
    reg timer_0_match = 1'b0;
    
    reg [32:0] counter = 32'b0;
    reg lighting = 1'b0;
    reg [7:0] press_count = 8'b0;
    
    reg [1:0] key_edge_detect = 2'b00;
    
    reg on = 1'b1;

    assign data = r_data;
    
    always @(posedge CLOCK_50) begin
    
        if (key_edge_detect == 2'b10) begin lighting <= 1'b1;
            counter <= 1'b0;
            press_count <= press_count + 1'b1;
            
            if (press_count == 16) begin
                press_count <= 1'b0;
                on <= !on;
            end
        end 
        
        if (lighting) begin
            if (counter == (32'd24 * press_count)) begin
                lighting <= 1'b0;
            end else begin
                if (state_reg == 4'b0 && state_set == 4'b0) begin
                    counter <= counter + 1'b1;
                    if (on) begin
                    state_set <= 4'b0001;
                    end else begin
                    state_set <= 4'b0100;
                    end
                end else begin
                    state_set <= 4'b0;
                end
            end
        end else begin
            state_set <= 4'b0;
        end
    end

    always @(posedge CLOCK_50) begin
        key_edge_detect <= {key_edge_detect[0], KEY[1]};
    end 

    always @(posedge CLOCK_50) begin
        if (timer_0_run) begin
            if (timer_0 == timer_0_compare) begin
                timer_0 <= 1'b0;
                timer_0_match <= 1'b1;
            end else begin
                timer_0 <= timer_0 + 1'b1;
                timer_0_match <= 1'b0;
            end
        end else begin
            timer_0 <= 1'b0;
            timer_0_match <= 1'b0;
        end
    end
    
    always @(posedge CLOCK_50) begin
        case (state_reg)
            4'b0000: begin
                    if (state_set != 4'b0) begin
                        state_reg <= state_set;
                    end
                    r_data <= 1'b0;
                end
            4'b0001: begin
                    if (timer_0_match) begin
                        timer_0_run <= 1'b0;
                        state_reg <= 4'b0010;
                    end else begin
                        r_data <= 1'b1;
                        timer_0_compare <= 7'd40; timer_0_run <= 1'b1;
                    end
                end
            4'b0010: begin
                    if (timer_0_match) begin
                        timer_0_run <= 1'b0;
                        state_reg <= 4'b0;
                    end else begin
                        r_data <= 1'b0;
                        timer_0_compare <= 7'd20; timer_0_run <= 1'b1;
                    end
                end
            4'b0100: begin
                    if (timer_0_match) begin
                        timer_0_run <= 1'b0;
                        state_reg <= 4'b1000;
                    end else begin
                        r_data <= 1'b1;
                        timer_0_compare <= 7'd20; timer_0_run <= 1'b1;
                    end
                end
            4'b1000: begin
                    if (timer_0_match) begin
                        timer_0_run <= 1'b0;
                        state_reg <= 4'b0;
                    end else begin
                        r_data <= 1'b0;
                        timer_0_compare <= 7'd40; timer_0_run <= 1'b1;
                    end
                end
            default: begin
                    state_reg <= 4'b0;
                end
        endcase
    end

endmodule