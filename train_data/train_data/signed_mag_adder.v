//145
module signed_mag_adder (
    input [15:0] A,
    input [15:0] B,
    output [15:0] sum
);

    wire [15:0] a_mag;
    wire [15:0] b_mag;
    wire a_sign;
    wire b_sign;

    // Determine the sign and magnitude of A
    assign a_sign = A[15];
    assign a_mag = (a_sign) ? ~A + 1 : A;

    // Determine the sign and magnitude of B
    assign b_sign = B[15];
    assign b_mag = (b_sign) ? ~B + 1 : B;

    // Add the magnitudes of A and B
    wire [15:0] mag_sum;
    assign mag_sum = (a_sign == b_sign) ? ((a_sign) ? ~(a_mag + b_mag) + 1 : a_mag + b_mag) :
                 ((a_mag > b_mag) ? ((a_sign) ? a_mag - b_mag : a_mag + b_mag) :
                                   ((b_sign) ? b_mag - a_mag : a_mag - b_mag));

    // Set the sign bit of the sum
    assign sum[15] = (mag_sum == 0) ? 1'b0 : 
                     (a_sign == b_sign) ? a_sign :
                     (a_mag > b_mag) ? a_sign : b_sign;

    // Assign the magnitude of the sum
    assign sum[14:0] = mag_sum[14:0];

endmodule