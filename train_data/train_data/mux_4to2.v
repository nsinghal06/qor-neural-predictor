//990
module mux_4to2 (
    input [3:0] D,
    input [3:0] S,
    output reg [1:0] Z
);

    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    always @* begin
        Z[0] = S[0] & D[0] | S[1] & D[1];
        Z[1] = S[2] & D[2] | S[3] & D[3];
    end

endmodule