module v9c4559 #(
 parameter v6c5139 = 1
) (
 input [23:0] v005b83,
 output v4642b6,
 output [23:0] v53d485
);
 localparam p1 = v6c5139;
 wire w0;
 wire [0:23] w2;
 wire [0:23] w3;
 assign v4642b6 = w0;
 assign w2 = v005b83;
 assign v53d485 = w3;
 v44c099 #(
  .vd73390(p1)
 ) v8c0045 (
  .v4642b6(w0),
  .vd90f46(w2),
  .v8826c0(w3)
 );
endmodule