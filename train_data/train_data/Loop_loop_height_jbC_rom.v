module Loop_loop_height_jbC_rom (
    input [7:0] addr0,
    input ce0,
    output reg [7:0] q0,
    input clk
);

    // ROM contents
    reg [7:0] rom [0:255];

   
    always @(posedge clk) begin
        if (ce0) begin
            q0 <= rom[addr0];
        end
    end

endmodule