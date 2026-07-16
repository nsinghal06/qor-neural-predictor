//754
module vendingMachine(
    input clk,
    input reset,
    input cola_button,
    input chips_button,
    input candy_button,
    input coin_slot,
    output reg cola_dispense,
    output reg chips_dispense,
    output reg candy_dispense,
    output reg coin_return,
    output [1:0] display
);

// Constants
parameter QUARTER_VALUE = 2'b01;
parameter DIME_VALUE = 2'b00;
parameter ITEM_COST = 2'b11;

// Registers
reg [1:0] coin_count;
reg [1:0] item_count;

// Combinational logic
assign display = coin_count;

// State machine
always @(posedge clk) begin
    if (reset) begin
        cola_dispense <= 0;
        chips_dispense <= 0;
        candy_dispense <= 0;
        coin_return <= 0;
        coin_count <= 0;
        item_count <= 0;
    end else begin
        case ({cola_button, chips_button, candy_button})
            // Cola button pressed
            3'b001: begin
                if (coin_count >= ITEM_COST) begin
                    cola_dispense <= 1;
                    coin_count <= coin_count - ITEM_COST;
                    item_count <= item_count + 1;
                end
            end
            // Chips button pressed
            3'b010: begin
                if (coin_count >= ITEM_COST) begin
                    chips_dispense <= 1;
                    coin_count <= coin_count - ITEM_COST;
                    item_count <= item_count + 1;
                end
            end
            // Candy button pressed
            3'b100: begin
                if (coin_count >= ITEM_COST) begin
                    candy_dispense <= 1;
                    coin_count <= coin_count - ITEM_COST;
                    item_count <= item_count + 1;
                end
            end
            // Coin return button pressed
            3'b000: begin
                coin_return <= 1;
                coin_count <= 0;
            end
        endcase

        // Coin slot
        if (coin_slot == QUARTER_VALUE) begin
            if (coin_count == 3) begin
                coin_return <= 1;
            end else begin
                coin_count <= coin_count + QUARTER_VALUE;
            end
        end else if (coin_slot == DIME_VALUE) begin
            if (coin_count == 7) begin
                coin_return <= 1;
            end else begin
                coin_count <= coin_count + DIME_VALUE;
            end
        end

        // Check for extra coins
        if (coin_count > ITEM_COST) begin
            coin_return <= 1;
            coin_count <= coin_count - ITEM_COST;
        end
    end
end

endmodule