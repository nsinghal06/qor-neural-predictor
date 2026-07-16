module case_overlap (
        input wire [2:0] x,
        input wire a, b, c, d, e,
        output reg o
);
        always @* begin
            case (x)
                0, 2: o = b; 1: o = c;
                default:
                    case (x)
                        0: o = 1'b1; 3, 4: o = d; 5: o = e;
                        default: o = 1'b0;
                    endcase
        endcase
        end
endmodule