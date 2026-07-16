//222
module peripheral_pwm (
    input clk,
    input rst,
    input [15:0] d_in,
    input cs,
    input [3:0] addr,
    input rd,
    input wr,
    output [2:0] pwm,
    output reg [15:0] d_out
);

    // Registers and wires
    reg [5:0] s;
    reg rst_n = 0;
    reg [9:0] number_1;
    reg [9:0] number_2;
    reg [9:0] number_3;
    wire [2:0] pwm_out;

    // Address decoder
    always @(*) begin
        case (addr)
            4'h0: s = (cs && wr) ? 5'b00001 : 5'b00000 ; // rst_n
            4'h2: s = (cs && wr) ? 5'b00010 : 5'b00000 ; // number_1
            4'h4: s = (cs && wr) ? 5'b00100 : 5'b00000 ; // number_2
            4'h6: s = (cs && wr) ? 5'b01000 : 5'b00000 ; // number_3
            4'h8: s = (cs && rd) ? 5'b10000 : 5'b00000 ; // pwm
            default: s = 5'b00000 ;
        endcase
    end

    // Register write
    always @(negedge clk) begin
        rst_n <= ~s[0];
        number_1 <= (s[1]) ? d_in [9:0] : number_1;
        number_2 <= (s[2]) ? d_in [9:0] : number_2;
        number_3 <= (s[3]) ? d_in [9:0] : number_3;
    end

    // Multiplex PWM signals
    always @(negedge clk) begin
        if (s[4]) begin
            d_out <= {13'b0, pwm_out};
        end
    end

    // PWM instances
    pwm u_pwm1 (.clk(clk), .rst_n(rst_n), .number(number_1), .pwm(pwm_out[0]));
    pwm u_pwm2 (.clk(clk), .rst_n(rst_n), .number(number_2), .pwm(pwm_out[1]));
    pwm u_pwm3 (.clk(clk), .rst_n(rst_n), .number(number_3), .pwm(pwm_out[2]));

    assign pwm = pwm_out;

endmodule

module pwm (
    input clk,
    input rst_n,
    input [9:0] number,
    output pwm
);

    reg pwm_reg = 0;
    reg [9:0] counter = 0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            pwm_reg <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == number) begin
                counter <= 0;
                pwm_reg <= ~pwm_reg;
            end
        end
    end

    assign pwm = pwm_reg;

endmodule