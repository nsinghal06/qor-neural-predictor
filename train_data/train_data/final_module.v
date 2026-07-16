//1220
module final_module (
    input  wire clk,
    input  wire reset, // Synchronous active-high reset
    input  wire [3:0] in, // 4-bit input for the "combinational_circuit" module
    input  wire [15:0] in_16, // 16-bit input for the "top_module" module
    output reg  [7:0] final_out // 8-bit output from the final module
);

// Instantiate the combinational_circuit and top_module modules.
wire comb_out;
combinational_circuit combinational_circuit_inst (
    .in(in),
    .or_out(),
    .and_out(),
    .xor_out(comb_out)
);

wire [7:0] upper_byte;
wire [7:0] lower_byte;
top_module top_module_inst (
    .in_16(in_16),
    .upper_byte(upper_byte),
    .lower_byte(lower_byte)
);

// Combine the outputs of the modules to create the final_out.
always @ (posedge clk) begin
  if (reset) begin
    final_out <= 0;
  end else begin
    final_out <= {comb_out, lower_byte};
  end
end

endmodule

module combinational_circuit(
    input wire [3:0] in,
    output wire or_out,
    output wire and_out,
    output wire xor_out
);

// Implement the combinational circuit.

endmodule

module top_module(
    input wire [15:0] in_16,
    output wire [7:0] upper_byte,
    output wire [7:0] lower_byte
);

// Implement the top module.

endmodule