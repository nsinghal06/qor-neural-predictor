//613
module comb_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);

    wire [7:0] temp;

    assign temp = {A[0]&B, A[1]&B, A[2]&B, A[3]&B};
    
    assign P = temp[0] + temp[1]*2 + temp[2]*4 + temp[3]*8 + temp[4]*16 + temp[5]*32 + temp[6]*64 + temp[7]*128;

endmodule