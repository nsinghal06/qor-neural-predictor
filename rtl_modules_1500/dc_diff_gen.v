//522
module dc_diff_gen(
    input clk,
    input ena,
    input rst,
    input dstrb,
    input signed [11:0] din,
    output signed [11:0] dout,
    output douten
);

    reg signed [11:0] prev_dc;
    reg signed [11:0] cur_dc;
    reg signed [11:0] diff;
    reg signed [11:0] dout_reg; // Register to store the differential signal
    reg douten_int; // Internal douten signal

    // Assign the output douten to the internal signal
    assign douten = douten_int;

    always @(posedge clk) begin
        if (rst) begin
            prev_dc <= 0;
            cur_dc <= 0;
            diff <= 0;
            dout_reg <= 0;
            douten_int <= 0;
        end else if (ena) begin
            // Update current DC component
            if (dstrb) begin
                cur_dc <= din;
            end

            // Calculate differential signal
            diff <= cur_dc - prev_dc;
            prev_dc <= cur_dc;

            // Output differential signal
            if (dstrb) begin
                // Change the assignment to dout to use the register
                dout_reg <= diff; 
                douten_int <= 1;
            end else begin
                douten_int <= 0;
            end
        end
    end

    // Assign the output dout to the register
    assign dout = dout_reg;

endmodule