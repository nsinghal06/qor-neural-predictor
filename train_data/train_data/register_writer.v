//563
module register_writer(
    clk_in,
    RST,
    ctrl_in,
    data,
    addr,
    data_out,
    addr_out,
    en_out
);

parameter CTRL_WIDTH = 4; // width of control signal
parameter DATA_WIDTH = 16; // width of data signal
parameter REG_ADDR_WIDTH = 8; // width of register address

// input / output
input clk_in, RST;
input [CTRL_WIDTH-1:0] ctrl_in;
input signed [DATA_WIDTH-1:0] data;
input [REG_ADDR_WIDTH-1:0] addr;

output reg signed [DATA_WIDTH-1:0] data_out;
output reg [REG_ADDR_WIDTH-1:0] addr_out;
output reg en_out;

// repasse dos enderecos data e addr
always @(posedge clk_in) begin
    data_out <= data;
    addr_out <= addr;
end

// execucao da gravacao nos registradores
always @(posedge clk_in) begin
    if (!RST) begin
        // rotina de reset
        en_out    <= 0;
	end else begin
        // Case para controle de habilitação de escrita no registrador de acordo com o opcode de entrada.
        case (ctrl_in)
        // ------------ Data Trasnfer -----------------
        4'b0000: en_out <= 1; // LW
        4'b0001: en_out <= 1; // LW_IMM
        // ------------ Arithmetic -----------------
        4'b0010: en_out <= 1; // ADD
        4'b0011: en_out <= 1; // SUB
        4'b0100: en_out <= 1; // MUL
        4'b0101: en_out <= 1; // DIV
        // ------------ Lógic -----------------
        4'b0110: en_out <= 1; // AND
        4'b0111: en_out <= 1; // OR
        4'b1000: en_out <= 1; // NOT
        // ------------ Control Transfer -----------------
        // All default
        default:  en_out <= 0;
        endcase
	 end
end

endmodule