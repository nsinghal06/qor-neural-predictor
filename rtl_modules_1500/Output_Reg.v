//1307
module Output_Reg
    #(parameter WIDTH = 8)
    (input [WIDTH-1:0] D,
     input E,
     input [1:0] FSM_selector_B,
     input clk_IBUF_BUFG,
     input [WIDTH-1:0] AR,
     output [WIDTH-1:0] Q);

    reg [WIDTH-1:0] Q_reg;

    always @(posedge clk_IBUF_BUFG) begin
        case (FSM_selector_B)
            2'b00: Q_reg <= Q_reg;
            2'b01: Q_reg <= D + Q_reg;
            2'b10: Q_reg <= D - Q_reg;
            2'b11: Q_reg <= AR;
        endcase
    end

    assign Q = Q_reg;

endmodule