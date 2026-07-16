module mux_if_unbal_5_3_invert #(parameter N=5, parameter W=3) (input [N*W-1:0] i, input [$clog2(N)-1:0] s, output reg [W-1:0] o);
always @*
    if (s != 0) 
	   	if (s != 1) 
			if (s != 2)
				if (s != 3)
					if (s != 4) o <= i[4*W+:W];
					else o <= i[0*W+:W];
				else o <= i[3*W+:W];
			else o <= i[2*W+:W];
		else o <= i[1*W+:W];
    else o <= {W{1'bx}};
endmodule