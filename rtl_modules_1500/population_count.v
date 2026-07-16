//970
module population_count(
    input [254:0] in,
    output [7:0] out
);

    reg [254:0] temp;
    reg [7:0] count;
    integer i;

    always @(*) begin
        temp = in;
        count = 0;
        for (i = 0; i < 255; i = i+1) begin
            count = count + temp[i];
        end
    end

    assign out = count;

endmodule