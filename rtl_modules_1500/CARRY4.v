//294
module CARRY4(output O0, O1, O2, O3, CO0, CO1, CO2, CO3, input DI0, DI1, DI2, DI3, S0, S1, S2, S3, CYINIT, CIN);
  assign {CO3, CO2, CO1, CO0} = DI3 & DI2 & DI1 & DI0 | (DI3 & DI2 & DI1) & (S0 | S1 | S2 | S3) | (DI3 & DI2) & (S1 | S2 | S3) | (DI3 & DI1) & (S2 | S3) | (DI3) & S3 | DI2 & DI1 & DI0 & (S1 | S2 | S3) | (DI2 & DI1) & (S2 | S3) | (DI2 & DI0) & S3 | DI1 & DI0 & S3;
  assign O3 = DI3 ^ S3;
  assign O2 = DI2 ^ S2 ^ O3;
  assign O1 = DI1 ^ S1 ^ O2;
  assign O0 = DI0 ^ S0 ^ O1;
endmodule