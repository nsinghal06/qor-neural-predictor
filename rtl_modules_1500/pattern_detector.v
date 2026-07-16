//399
module pattern_detector (
    input a,b,c,d, // Inputs to the multiplexer
    input [7:0] in, // Input to the priority encoder
    output w,x,y,z, // Outputs from the multiplexer
    output reg [2:0] pos, // Output from the priority encoder
    output [7:0] out // Output from the functional module
);

    // Multiplexer
    assign w = a? in[3:0] : 4'b0000;
    assign x = b? in[3:0] : 4'b0000;
    assign y = c? in[3:0] : 4'b0000;
    assign z = d? in[3:0] : 4'b0000;

    // Priority Encoder
    always @* begin
        if (|w) pos = 3;
        else if (|x) pos = 2;
        else if (|y) pos = 1;
        else if (|z) pos = 0;
        else pos = 0;
    end

    // Functional Module
    assign out = w ^ x ^ y ^ z;

endmodule