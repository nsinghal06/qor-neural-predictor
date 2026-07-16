module control_logic (
    input select, // Select input to choose between shift register and counter
    input [7:0] shift_reg_out, // Output from the shift register
    input [3:0] count_out, // Output from the counter
    output [7:0] active_out // Output from the active module
);

assign active_out = select ? count_out : shift_reg_out;

endmodule