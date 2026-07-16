//1063
module block_mem_gen
    (douta,
     clka,
     ena,
     addra,
     dina,
     wea);

    output [7:0] douta;
    input clka;
    input ena;
    input [7:0] addra;
    input [7:0] dina;
    input wea;

    wire [7:0] douta;
    wire clka;
    wire ena;
    wire [7:0] addra;
    wire [7:0] dina;
    wire wea;

    reg [7:0] douta_reg;

    always @ (posedge clka) begin
        if (ena) begin
            if (wea) begin
                douta_reg <= dina;
            end
        end
    end

    assign douta = douta_reg;
endmodule