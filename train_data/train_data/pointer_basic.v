//882
module pointer_basic (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        d_i,
        d_o,
        d_o_ap_vld
);

parameter    ap_ST_fsm_state1 = 1'd1;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [31:0] d_i;
output  [31:0] d_o;
output   d_o_ap_vld;

reg ap_done;
reg ap_idle;
reg ap_ready;
reg d_o_ap_vld;

 reg   [0:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg   [31:0] acc;
wire   [31:0] acc_assign_fu_31_p2;
reg   [0:0] ap_NS_fsm;

initial begin
#0 ap_CS_fsm = 1'd1;
#0 acc = 32'd0;
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (((ap_start == 1'b1) & (1'b1 == ap_CS_fsm_state1))) begin
        acc <= acc_assign_fu_31_p2;
    end
end

always @ (*) begin
    if (((ap_start == 1'b1) & (1'b1 == ap_CS_fsm_state1))) begin
        ap_done = 1'b1;
    end else begin
        ap_done = 1'b0;
    end
end

always @ (*) begin
    if (((ap_start == 1'b0) & (1'b1 == ap_CS_fsm_state1))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((ap_start == 1'b1) & (1'b1 == ap_CS_fsm_state1))) begin
        ap_ready = 1'b1;
    end else begin
        ap_ready = 1'b0;
    end
end

always @ (*) begin
    if (((ap_start == 1'b1) & (1'b1 == ap_CS_fsm_state1))) begin
        d_o_ap_vld = 1'b1;
    end else begin
        d_o_ap_vld = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            ap_NS_fsm = ap_ST_fsm_state1;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign acc_assign_fu_31_p2 = (acc + d_i);

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign d_o = (acc + d_i);

endmodule