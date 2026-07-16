//206
module DRAMWriter(
    //AXI port
    input wire ACLK,
    input wire ARESETN,
    output reg [31:0] M_AXI_AWADDR,
    input wire M_AXI_AWREADY,
    output wire M_AXI_AWVALID,
    
    output wire [63:0] M_AXI_WDATA,
    output wire [7:0] M_AXI_WSTRB,
    input wire M_AXI_WREADY,
    output wire M_AXI_WVALID,
    output wire M_AXI_WLAST,
    
    input wire [1:0] M_AXI_BRESP,
    input wire M_AXI_BVALID,
    output wire M_AXI_BREADY,
    
    output wire [3:0] M_AXI_AWLEN,
    output wire [1:0] M_AXI_AWSIZE,
    output wire [1:0] M_AXI_AWBURST,
    
    //Control config
    input wire CONFIG_VALID,
    output wire CONFIG_READY,
    input wire [31:0] CONFIG_START_ADDR,
    input wire [31:0] CONFIG_NBYTES,
    
    //RAM port
    input wire [63:0] DATA,
    output wire DATA_READY,
    input wire DATA_VALID

);

parameter IDLE = 2'b00, WRITE = 2'b01, RWAIT = 2'b10, BRESP_WAIT = 2'b11;
parameter BRESP_OKAY = 2'b00, BRESP_EXOKAY = 2'b01, BRESP_SLVERR = 2'b10, BRESP_DECERR = 2'b11;

reg [31:0] a_count;
reg a_state;  
assign M_AXI_AWVALID = (a_state == RWAIT);
always @(posedge ACLK) begin
    if (ARESETN == 0) begin
        a_state <= IDLE;
        M_AXI_AWADDR <= 0;
        a_count <= 0;
    end else case(a_state)
        IDLE: begin
            if(CONFIG_VALID) begin
                M_AXI_AWADDR <= CONFIG_START_ADDR;
                a_count <= CONFIG_NBYTES[31:7];
                a_state <= RWAIT;
            end
        end
        RWAIT: begin
            if (M_AXI_AWREADY == 1) begin
                if(a_count - 1 == 0)
                    a_state <= IDLE;
                a_count <= a_count - 1;
                M_AXI_AWADDR <= M_AXI_AWADDR + 128; 
            end
        end
    endcase
end

reg [31:0] b_count;
reg w_state;
reg [3:0] last_count;
reg [1:0] bresp_state;

always @(posedge ACLK) begin
    if (ARESETN == 0) begin
        w_state <= IDLE;
        b_count <= 0;
        last_count <= 4'b1111;
        bresp_state <= BRESP_OKAY;
    end else case(w_state)
        IDLE: begin
            if(CONFIG_VALID) begin
                b_count <= {CONFIG_NBYTES[31:7],7'b0};
                w_state <= WRITE;
            end
        end
        WRITE: begin
            if (M_AXI_WREADY && M_AXI_WVALID) begin
                //use M_AXI_WDATA
                if(b_count - 8 == 0) begin
                    w_state <= IDLE;
                end
                last_count <= last_count - 4'b1;
                b_count <= b_count - 8;
            end
        end
    endcase
end

assign M_AXI_WLAST = (last_count == 4'b0000);

assign M_AXI_WVALID = (w_state == WRITE) && DATA_VALID;

assign DATA_READY = (w_state == WRITE) && M_AXI_WREADY;
   
assign CONFIG_READY = (w_state == IDLE) && (a_state == IDLE);

assign M_AXI_BREADY = 1;

assign M_AXI_WDATA = DATA;

always @(posedge ACLK) begin
    if (ARESETN == 0) begin
        bresp_state <= BRESP_OKAY;
    end else case(bresp_state)
        BRESP_OKAY: begin
            if(M_AXI_BVALID) begin
                if(M_AXI_BRESP != 2'b00) begin
                    bresp_state <= BRESP_SLVERR;
                end else begin
                    if(w_state == WRITE) begin
                        bresp_state <= BRESP_WAIT;
                    end
                end
            end
        end
        BRESP_WAIT: begin
            if(M_AXI_BREADY) begin
                bresp_state <= BRESP_OKAY;
            end
        end
        BRESP_SLVERR: begin
            bresp_state <= BRESP_OKAY;
        end
    endcase
end

assign M_AXI_BRESP = bresp_state;

//default value of unused wires
assign M_AXI_WSTRB = 8'b11111111;
assign M_AXI_AWSIZE = 2'b00;
assign M_AXI_AWLEN = 4'b0000;
assign M_AXI_AWBURST = 2'b00;

endmodule