//473
module johnson_binary_counter (
    input clk,
    input rst_n,
    input select,
    output reg [63:0] Q
);

reg [5:0] johnson_state;
reg [3:0] binary_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        johnson_state <= 6'b000001;
        binary_state <= 4'b0000;
        Q <= 64'b0;
    end else begin
        if (select) begin
            // Johnson counter
            case (johnson_state)
                6'b000001: johnson_state <= 6'b000010;
                6'b000010: johnson_state <= 6'b000100;
                6'b000100: johnson_state <= 6'b001000;
                6'b001000: johnson_state <= 6'b010000;
                6'b010000: johnson_state <= 6'b100000;
                6'b100000: johnson_state <= 6'b000001;
            endcase
            Q <= {johnson_state[5], johnson_state[4], johnson_state[3], johnson_state[2], johnson_state[1], johnson_state[0], 2'b00};
        end else begin
            // Binary counter
            if (binary_state == 4'b1111) begin
                binary_state <= 4'b0000;
            end else begin
                binary_state <= binary_state + 1;
            end
            Q <= {4'b0000, binary_state};
        end
    end
end

endmodule

module top_module (
    input clk,
    input rst_n,
    input select,
    output [63:0] Q
);

wire [63:0] johnson_out;
wire [63:0] binary_out;

johnson_binary_counter johnson_counter (
    .clk(clk),
    .rst_n(rst_n),
    .select(1'b1),
    .Q(johnson_out)
);

johnson_binary_counter binary_counter (
    .clk(clk),
    .rst_n(rst_n),
    .select(select),
    .Q(binary_out)
);

assign Q = select ? binary_out : johnson_out;

endmodule