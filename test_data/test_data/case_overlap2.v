module case_overlap2 (
        input wire [2:0] x,
        input wire a, b, c, d, e,
        output reg o
);
        always @* begin
            case (x)
                0: o = b; 2: o = b; 1: o = c;
                default:
                    case (x)
                        0: o = d; 2: o = d; 3: o = d; 4: o = d; 5: o = e;
                        default: o = 1'b0;
                    endcase
        endcase
        end
endmodule