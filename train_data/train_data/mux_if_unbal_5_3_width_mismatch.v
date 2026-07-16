module mux_if_unbal_5_3_width_mismatch #(parameter N=5, parameter W=3) (input [N*W-1:0] i, input [$clog2(N)-1:0] s, output reg [W-1:0] o);
always @* begin
    o <= {W{1'bx}};
    if (s == 0) o <= i[0*W+:W];
    if (s == 1) o <= i[1*W+:W];
    if (s == 2) o[W-2:0] <= i[2*W+:W-1];
    if (s == 3) o <= i[3*W+:W];
    if (s == 4) o <= i[4*W+:W];
end
endmodule