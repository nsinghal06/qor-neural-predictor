//369
module barrel_mux(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

reg [3:0] mux_out;

always @(*) begin
    case(sel[2:0])
        3'b000: mux_out = in[255:252];
        3'b001: mux_out = in[259:256];
        3'b010: mux_out = in[263:260];
        3'b011: mux_out = in[267:264];
        3'b100: mux_out = in[271:268];
        3'b101: mux_out = in[275:272];
        3'b110: mux_out = in[279:276];
        3'b111: mux_out = in[283:280];
        default: mux_out = 4'b0;
    endcase
end

assign out = mux_out;

endmodule

module top_module( 
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out );

wire [3:0] mux_out;

barrel_mux mux(
    .in(in),
    .sel(sel),
    .out(mux_out)
);

assign out = mux_out;

endmodule