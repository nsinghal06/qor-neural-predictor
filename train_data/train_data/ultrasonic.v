//1008
module ultrasonic #( parameter N = 16 , CONSTANT = 20'd588 ) ( 
    input clk,
    input signal,
    input rst_n,
    output reg [N-1:0] value , 
    output reg done 
    );

    reg [1:0]	state ;
    reg [N-1:0] count_1 ;

    parameter S0 = 2'b00 ;
    parameter S1 = 2'b01 ;
    parameter S2 = 2'b10 ;

    always @ ( negedge clk ) 
        if ( ~rst_n )
            state <= S0 ;
        else
            case ( state ) 
                S0 : 
                    if ( signal )
                        state <= S1 ;
                    else 
                        state <= S0 ;
                S1 :
                    if ( ~signal )
                        state <= S2 ;
                    else
                        state <= S1 ;
            endcase

    always @( posedge clk )
        case ( state ) 
            S0 : begin
                count_1 <= 0 ;
                value <= 0 ;
                done <= 0 ;
            end S1 : begin
                if ( CONSTANT == count_1 ) begin
                    count_1 <= 1 ;
                    value <= value + 1'b1 ;
                    done <= 0 ; 
                end else begin  
                    count_1 <= count_1 + 1'b1 ;
                    value <= value ;
                    done <= 0 ;
                end
            end S2 : begin
                count_1 <= 0 ;
                value <= value ;
                done <= 1 ;
            end
        endcase

endmodule