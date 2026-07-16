module v053dc2 #(
 parameter v71e305 = 0
) (
 input va4102a,
 input vf54559,
 output ve8318d
);
 localparam p2 = v71e305;
 wire w0;
 wire w1;
 wire w3;
 assign w0 = va4102a;
 assign ve8318d = w1;
 assign w3 = vf54559;
 v053dc2_vb8adf8 #(
  .INI(p2)
 ) vb8adf8 (
  .clk(w0),
  .q(w1),
  .d(w3)
 );
endmodule