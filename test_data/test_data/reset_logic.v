//1140
module reset_logic(
    input RESET,
    input USER_CLK,
    input INIT_CLK,
    input GT_RESET_IN,
    output SYSTEM_RESET,
    output GT_RESET_OUT
);

// Debounce the user reset button using USER_CLK
reg [3:0] reset_debounce_r = 4'b0;
always @(posedge USER_CLK) begin
    if (RESET) reset_debounce_r <= {reset_debounce_r[2:0], 1'b1};
    else reset_debounce_r <= {reset_debounce_r[2:0], 1'b0};
end

// Generate the system reset signal from the debounced user reset button signal
reg SYSTEM_RESET_reg = 1'b1;
always @(posedge USER_CLK) begin
    if (reset_debounce_r == 4'b1111) SYSTEM_RESET_reg <= 1'b0;
    else SYSTEM_RESET_reg <= 1'b1;
end
assign SYSTEM_RESET = SYSTEM_RESET_reg;

// Debounce the PMA reset signal using INIT_CLK
reg [3:0] gt_reset_debounce_r = 4'b0;
always @(posedge INIT_CLK) begin
    gt_reset_debounce_r <= {gt_reset_debounce_r[2:0], GT_RESET_IN};
end

// Delay the assertion of the reset signal to the GT module
reg [19:0] gt_reset_delay_r = 20'h00000;
always @(posedge INIT_CLK) begin
    gt_reset_delay_r <= {gt_reset_delay_r[18:0], gt_reset_debounce_r[3]};
end
assign GT_RESET_OUT = gt_reset_delay_r[18];

endmodule