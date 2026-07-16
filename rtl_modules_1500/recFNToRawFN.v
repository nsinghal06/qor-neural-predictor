//541
module recFNToRawFN#(parameter expWidth = 3, parameter sigWidth = 3) (
    input [(expWidth + sigWidth):0] in,
    output isNaN,
    output isInf,
    output isZero,
    output sign,
    output signed [(expWidth + 1):0] sExp,
    output [sigWidth:0] sig
);


wire [expWidth:0] exp;
wire [(sigWidth - 2):0] fract;
assign {sign, exp, fract} = in;


wire isSpecial = (exp>>(expWidth - 1) == 'b11);


assign isNaN = isSpecial &&  exp[expWidth - 2];


assign isInf = isSpecial && !exp[expWidth - 2];


assign isZero = (exp>>(expWidth - 2) == 'b000);


assign sExp = exp;
assign sig = {1'b0, !isZero, fract};

endmodule