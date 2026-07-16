//211
module antares_multiplier(
                          input         clk,            input         rst,            input [31:0]  mult_input_a,   input [31:0]  mult_input_b,   input         mult_signed_op, input         mult_enable_op, input         mult_stall,     input         flush,          output [63:0] mult_result,    output        mult_active,    output        mult_ready      );

    reg [32:0]    A;
    reg [32:0]    B;
    reg [31:0]    result_ll_0;
    reg [31:0]    result_lh_0;
    reg [31:0]    result_hl_0;
    reg [31:0]    result_hh_0; reg [31:0]    result_ll_1;
    reg [31:0]    result_hh_1; reg [32:0]    result_mid_1;
    reg [63:0]    result_mult;

    reg           active0;     reg           active1;
    reg           active2;
    reg           active3;
    reg           sign_result0;
    reg           sign_result1;
    reg           sign_result2;
    reg           sign_result3;

    wire          sign_a;
    wire          sign_b;
    wire [47:0]   partial_sum;
    wire [32:0]   a_sign_ext;
    wire [32:0]   b_sign_ext;

    assign sign_a      = (mult_signed_op) ? mult_input_a[31] : 1'b0;
    assign sign_b      = (mult_signed_op) ? mult_input_b[31] : 1'b0;
    assign a_sign_ext  = {sign_a, mult_input_a};
    assign b_sign_ext  = {sign_b, mult_input_b};
    assign partial_sum = {15'b0, result_mid_1} + {result_hh_1[31:0], result_ll_1[31:16]};
    assign mult_result = (sign_result3) ? -result_mult : result_mult;                         assign mult_ready  = active3;
    assign mult_active = active0 | active1 | active2 | active3;                             always @(posedge clk) begin
        if (rst | flush) begin
            
            A <= 33'h0;
            B <= 33'h0;
            active0 <= 1'h0;
            active1 <= 1'h0;
            active2 <= 1'h0;
            active3 <= 1'h0;
            result_hh_0 <= 32'h0;
            result_hh_1 <= 32'h0;
            result_hl_0 <= 32'h0;
            result_lh_0 <= 32'h0;
            result_ll_0 <= 32'h0;
            result_ll_1 <= 32'h0;
            result_mid_1 <= 33'h0;
            result_mult <= 64'h0;
            sign_result0 <= 1'h0;
            sign_result1 <= 1'h0;
            sign_result2 <= 1'h0;
            sign_result3 <= 1'h0;
            end
        else if(~mult_stall) begin
            A            <= sign_a ? -a_sign_ext : a_sign_ext;
            B            <= sign_b ? -b_sign_ext : b_sign_ext;
            sign_result0 <= sign_a ^ sign_b;
            active0      <= mult_enable_op;
            result_ll_0  <= A[15:0]  *  B[15:0];       result_lh_0  <= A[15:0]  *  B[32:16];      result_hl_0  <= A[32:16] *  B[15:0];       result_hh_0  <= A[31:16] *  B[31:16];      sign_result1 <= sign_result0;
            active1      <= active0;
            result_ll_1  <= result_ll_0;
            result_hh_1  <= result_hh_0;
            result_mid_1 <= result_lh_0 + result_hl_0;      sign_result2 <= sign_result1;
            active2      <= active1;
            result_mult  <= {partial_sum, result_ll_1[15:0]};
            sign_result3 <= sign_result2;
            active3      <= active2;
        end
    end

endmodule