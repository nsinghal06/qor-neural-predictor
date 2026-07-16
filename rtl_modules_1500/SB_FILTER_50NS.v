//214
module SB_FILTER_50NS(
    input clk, // clock signal
    input FILTERIN, // input signal
    output FILTEROUT // filtered output signal
);

    parameter FILTER_WIDTH = 50; // width of filter in nanoseconds
    parameter CLOCK_PERIOD = 10; // clock period in nanoseconds
    
    reg [FILTER_WIDTH/CLOCK_PERIOD-1:0] shift_register; // shift register to store previous N bits
    reg FILTEROUT_reg; // register to hold filtered output
    
    always @(posedge clk) begin
        // shift register
        shift_register <= {shift_register[FILTER_WIDTH/CLOCK_PERIOD-2:0], FILTERIN};
        
        // check if input has been present for at least FILTER_WIDTH nanoseconds
        if (shift_register == {{FILTER_WIDTH/CLOCK_PERIOD-1{1'b1}}, 1'b0}) begin
            FILTEROUT_reg <= 1'b1; // pass input through
        end else begin
            FILTEROUT_reg <= 1'b0; // discard input
        end
    end
    
    assign FILTEROUT = FILTEROUT_reg;

endmodule