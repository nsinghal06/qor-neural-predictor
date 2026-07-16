//883
module mux_wire_connection (
    input [1:0] data, // Input to the mux_2to1 module
    input ctrl, // Control input to select between the two modules
    input a,b,c, // Inputs to the wire_connection module
    output w,x,y,z, // Outputs from the wire_connection module
    output wire out // Output from the mux_2to1 module
);
wire [3:0] data_wire;
// Instantiate the wire_connection module
wire_connection wire_conn(
    .a(a),
    .b(b),
    .c(c),
    .w(w),
    .x(x),
    .y(y),
    .z(z)
);

// Instantiate the mux_2to1 module
mux_2to1 #(
    .N(4) // Specify the number of inputs to the mux
) mux(
    .data(data_wire),
    .ctrl(ctrl),
    .out(out)
);

assign data_wire = {w,x,y,z};

endmodule

module wire_connection (
    input a,b,c,
    output wire w,x,y,z
);

assign w = a & b;
assign x = a | b;
assign y = c ^ b;
assign z = ~(a & c);

endmodule

module mux_2to1 #(
    parameter N=2 // Default value for the number of inputs
) (
    input [N-1:0] data,
    input ctrl,
    output reg out
);

always @ (*) begin
    if (ctrl) begin
        out = data[1]; // Select the second input
    end else begin
        out = data[0]; // Select the first input
    end
end

endmodule