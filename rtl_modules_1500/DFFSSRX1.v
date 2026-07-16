//1448
module DFFSSRX1 (input CLK, D, output Q, QN, input RSTB, SETB, VDD, VSS);

    reg Q, QN;

    always @(posedge CLK) begin
        if (RSTB == 0) begin
            Q <= 0;
            QN <= 1;
        end else if (SETB == 0) begin
            Q <= 1;
            QN <= 0;
        end else begin
            Q <= D;
            QN <= ~D;
        end
    end

endmodule