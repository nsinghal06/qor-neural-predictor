module mux_case_unbal_8_7#(parameter N=8, parameter W=7) (input [N*W-1:0] i, input [$clog2(N)-1:0] s, output reg [W-1:0] o);
always @* begin
    o <= {W{1'bx}};
    case (s)
    0: o <= i[0*W+:W];
    default:
        case (s)
        1: o <= i[1*W+:W];
        2: o <= i[2*W+:W];
        default:
            case (s)
            3: o <= i[3*W+:W];
            4: o <= i[4*W+:W];
            5: o <= i[5*W+:W];
            default:
                case (s)
                    6: o <= i[6*W+:W];
                    default: o <= i[7*W+:W];
                endcase
            endcase
        endcase
    endcase
end
endmodule