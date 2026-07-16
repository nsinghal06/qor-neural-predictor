module majority(output out, input a, input b, input c);
    wire ab, bc, ac;
    and(ab, a, b);
    and(bc, b, c);
    and(ac, a, c);
    or(out, ab, bc, ac);
endmodule