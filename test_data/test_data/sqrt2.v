//782
module sqrt2 (
  input [31:0] in,
  output reg [15:0] out
);

  reg [15:0] guess;
  reg [31:0] temp;
  integer i;

  always @(*) begin

    guess = 16'd1;
    temp = in;

    for (i = 1; i < 100; i = i + 1) 
      if (guess * guess <= temp) 
        guess = guess + 1;

    out = guess - 1;

  end

endmodule