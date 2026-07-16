//375
module addsub4bit(
    input [3:0] A,
    input [3:0] B,
    input S,
    input C,
    output reg [3:0] F,
    output reg C_out
);

reg [4:0] temp; // range is increased by 1-bit

always @ (*)
begin
    if(S == 1) // subtraction
    begin
        temp = A - B;
        if(C == 1) temp = temp - 1;
        F <= temp[3:0]; // range selection
        C_out <= (temp[4] == 1) ? 0 : 1;
    end
    else // addition
    begin
        temp = A + B;
        if(C == 1) temp = temp + 1;
        F <= temp[3:0]; // range selection
        C_out <= (temp[4] == 1) ? 1 : 0;
    end
end

endmodule