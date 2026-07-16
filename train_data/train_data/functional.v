module functional (
    input greater_than,
    input less_than,
    input equal,
    output reg [1:0] functional_out
);

    always @(*) begin
        if (greater_than) begin
            functional_out = 2'b10;
        end else if (less_than) begin
            functional_out = 2'b00;
        end else if (equal) begin
            functional_out = 2'b01;
        end
    end

endmodule