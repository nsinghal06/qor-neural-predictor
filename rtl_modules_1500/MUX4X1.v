//1401
module MUX4X1 (
	D0,
	D1,
	D2,
	D3,
	S0,
	S1,
	Y
);
   input D0;
   input D1;
   input D2;
   input D3;
   input S0;
   input S1;
   output Y;

   wire not_S0;
   wire not_S1;
   wire and_0;
   wire and_1;
   wire and_2;
   wire and_3;
   wire or_0;
   wire or_1;
   wire or_2;

   // Implementing the 4:1 Multiplexer using only the allowed primitives
   // The truth table is:
   // S1 | S0 || Y
   // ---|----||---
   //  0 |  0 || D0
   //  0 |  1 || D1
   //  1 |  0 || D2
   //  1 |  1 || D3

   // Implementing the not gates
   not (not_S0, S0);
   not (not_S1, S1);

   // Implementing the and gates
   and (and_0, D0, not_S1);
   and (and_1, D1, S1);
   and (and_2, D2, not_S0);
   and (and_3, D3, S0);

   // Implementing the or gates
   or (or_0, and_0, and_1);
   or (or_1, and_2, and_3);

   // Implementing the final or gate
   or (Y, or_0, or_1);
endmodule