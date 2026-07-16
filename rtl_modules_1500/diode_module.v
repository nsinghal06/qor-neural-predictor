//672
module diode_module (
    input DIODE,
    input VPB,
    input VPWR,
    input VGND,
    input VNB,
    output reg OUT
);

always @(*) begin
    if (DIODE == 1) begin
        OUT = (VPB > VPWR) ? (VPB - ((VGND > VNB) ? VGND : VNB)) : (VPWR - ((VGND > VNB) ? VGND : VNB));
    end else begin
        OUT = VPWR - ((VGND > VNB) ? VGND : VNB);
    end
end

endmodule