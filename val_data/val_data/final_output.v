module final_output (
    input rise_edge,
    input fall_edge,
    input [1:0] priority_encoder,
    output reg [1:0] out
);

always @(*) begin
    if (rise_edge) begin
        out = priority_encoder;
    end else if (fall_edge) begin
        out = ~priority_encoder;
    end else begin
        out = 2'b00;
    end
end

endmodule