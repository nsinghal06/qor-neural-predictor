//424
module axis_async_fifo #
(
    parameter DEPTH = 4096,
    parameter DATA_WIDTH = 8,
    parameter KEEP_ENABLE = (DATA_WIDTH>8),
    parameter KEEP_WIDTH = (DATA_WIDTH/8),
    parameter LAST_ENABLE = 1,
    parameter ID_ENABLE = 0,
    parameter ID_WIDTH = 8,
    parameter DEST_ENABLE = 0,
    parameter DEST_WIDTH = 8,
    parameter USER_ENABLE = 1,
    parameter USER_WIDTH = 1,
    parameter PIPELINE_OUTPUT = 2,
    parameter FRAME_FIFO = 0,
    parameter USER_BAD_FRAME_VALUE = 1'b1,
    parameter USER_BAD_FRAME_MASK = 1'b1,
    parameter DROP_BAD_FRAME = 0,
    parameter DROP_WHEN_FULL = 0
)
(
    
    input  wire                   async_rst,

    
    input  wire                   s_clk,
    input  wire [DATA_WIDTH-1:0]  s_axis_tdata,
    input  wire [KEEP_WIDTH-1:0]  s_axis_tkeep,
    input  wire                   s_axis_tvalid,
    output wire                   s_axis_tready,
    input  wire                   s_axis_tlast,
    input  wire [ID_WIDTH-1:0]    s_axis_tid,
    input  wire [DEST_WIDTH-1:0]  s_axis_tdest,
    input  wire [USER_WIDTH-1:0]  s_axis_tuser,

    
    input  wire                   m_clk,
    output wire [DATA_WIDTH-1:0]  m_axis_tdata,
    output wire [KEEP_WIDTH-1:0]  m_axis_tkeep,
    output wire                   m_axis_tvalid,
    input  wire                   m_axis_tready,
    output wire                   m_axis_tlast,
    output wire [ID_WIDTH-1:0]    m_axis_tid,
    output wire [DEST_WIDTH-1:0]  m_axis_tdest,
    output wire [USER_WIDTH-1:0]  m_axis_tuser,

    
    output wire                   s_status_overflow,
    output wire                   s_status_bad_frame,
    output wire                   s_status_good_frame,
    output wire                   m_status_overflow,
    output wire                   m_status_bad_frame,
    output wire                   m_status_good_frame
);

parameter ADDR_WIDTH = (KEEP_ENABLE && KEEP_WIDTH > 1) ? $clog2(DEPTH/KEEP_WIDTH) : $clog2(DEPTH);

initial begin
    if (PIPELINE_OUTPUT < 1) begin
        $error("Error: PIPELINE_OUTPUT must be at least 1 (instance %m)");
        $finish;
    end

    if (FRAME_FIFO && !LAST_ENABLE) begin
        $error("Error: FRAME_FIFO set requires LAST_ENABLE set (instance %m)");
        $finish;
    end

    if (DROP_BAD_FRAME && !FRAME_FIFO) begin
        $error("Error: DROP_BAD_FRAME set requires FRAME_FIFO set (instance %m)");
        $finish;
    end

    if (DROP_WHEN_FULL && !FRAME_FIFO) begin
        $error("Error: DROP_WHEN_FULL set requires FRAME_FIFO set (instance %m)");
        $finish;
    end

    if (DROP_BAD_FRAME && (USER_BAD_FRAME_MASK & {USER_WIDTH{1'b1}}) == 0) begin
        $error("Error: Invalid USER_BAD_FRAME_MASK value (instance %m)");
        $finish;
    end
end

localparam KEEP_OFFSET = DATA_WIDTH;
localparam LAST_OFFSET = KEEP_OFFSET + (KEEP_ENABLE ? KEEP_WIDTH : 0);
localparam ID_OFFSET   = LAST_OFFSET + (LAST_ENABLE ? 1          : 0);
localparam DEST_OFFSET = ID_OFFSET   + (ID_ENABLE   ? ID_WIDTH   : 0);
localparam USER_OFFSET = DEST_OFFSET + (DEST_ENABLE ? DEST_WIDTH : 0);
localparam WIDTH       = USER_OFFSET + (USER_ENABLE ? USER_WIDTH : 0);

reg [ADDR_WIDTH:0] wr_ptr_reg = {ADDR_WIDTH+1{1'b0}};
reg [ADDR_WIDTH:0] wr_ptr_cur_reg = {ADDR_WIDTH+1{1'b0}};
reg [ADDR_WIDTH:0] wr_ptr_gray_reg = {ADDR_WIDTH+1{1'b0}};
reg [ADDR_WIDTH:0] wr_ptr_sync_gray_reg = {ADDR_WIDTH+1{1'b0}};
reg [ADDR_WIDTH:0] wr_ptr_cur_gray_reg = {ADDR_WIDTH+1{1'b0}};
reg [ADDR_WIDTH:0] rd_ptr_reg = {ADDR_WIDTH+1{1'b0}};
reg [ADDR_WIDTH:0] rd_ptr_gray_reg = {ADDR_WIDTH+1{1'b0}};

reg [ADDR_WIDTH:0] wr_ptr_temp;
reg [ADDR_WIDTH:0] rd_ptr_temp;


reg [ADDR_WIDTH:0] wr_ptr_gray_sync1_reg = {ADDR_WIDTH+1{1'b0}};

reg [ADDR_WIDTH:0] wr_ptr_gray_sync2_reg = {ADDR_WIDTH+1{1'b0}};

reg [ADDR_WIDTH:0] rd_ptr_gray_sync1_reg = {ADDR_WIDTH+1{1'b0}};

reg [ADDR_WIDTH:0] rd_ptr_gray_sync2_reg = {ADDR_WIDTH+1{1'b0}};

reg wr_ptr_update_valid_reg = 1'b0;
reg wr_ptr_update_reg = 1'b0;

reg wr_ptr_update_sync1_reg = 1'b0;

reg wr_ptr_update_sync2_reg = 1'b0;

reg wr_ptr_update_sync3_reg = 1'b0;

reg wr_ptr_update_ack_sync1_reg = 1'b0;

reg wr_ptr_update_ack_sync2_reg = 1'b0;


reg s_rst_sync1_reg = 1'b1;

reg s_rst_sync2_reg = 1'b1;

reg s_rst_sync3_reg = 1'b1;

reg m_rst_sync1_reg = 1'b1;

reg m_rst_sync2_reg = 1'b1;

reg m_rst_sync3_reg = 1'b1;

reg [WIDTH-1:0] mem[(2**ADDR_WIDTH)-1:0];
reg [WIDTH-1:0] mem_read_data_reg;
reg mem_read_data_valid_reg = 1'b0;

wire [WIDTH-1:0] s_axis;


reg [WIDTH-1:0] m_axis_pipe_reg[PIPELINE_OUTPUT-1:0];

reg [PIPELINE_OUTPUT-1:0] m_axis_tvalid_pipe_reg = 1'b0;

wire full = wr_ptr_gray_reg == (rd_ptr_gray_sync2_reg ^ {2'b11, {ADDR_WIDTH-1{1'b0}}});
wire full_cur = wr_ptr_cur_gray_reg == (rd_ptr_gray_sync2_reg ^ {2'b11, {ADDR_WIDTH-1{1'b0}}});
wire empty = rd_ptr_gray_reg == (FRAME_FIFO ? wr_ptr_gray_sync1_reg : wr_ptr_gray_sync2_reg);
wire full_wr = wr_ptr_reg == (wr_ptr_cur_reg ^ {1'b1, {ADDR_WIDTH{1'b0}}});

reg write;
reg read;
reg store_output;

reg drop_frame_reg = 1'b0;
reg overflow_reg = 1'b0;
reg bad_frame_reg = 1'b0;
reg good_frame_reg = 1'b0;

reg overflow_sync1_reg = 1'b0;
reg overflow_sync2_reg = 1'b0;
reg overflow_sync3_reg = 1'b0;
reg overflow_sync4_reg = 1'b0;
reg bad_frame_sync1_reg = 1'b0;
reg bad_frame_sync2_reg = 1'b0;
reg bad_frame_sync3_reg = 1'b0;
reg bad_frame_sync4_reg = 1'b0;
reg good_frame_sync1_reg = 1'b0;
reg good_frame_sync2_reg = 1'b0;
reg good_frame_sync3_reg = 1'b0;
reg good_frame_sync4_reg = 1'b0;

assign s_axis_tready = (FRAME_FIFO ? (!full_cur || full_wr || DROP_WHEN_FULL) : !full) && !s_rst_sync3_reg;

generate
    assign s_axis[DATA_WIDTH-1:0] = s_axis_tdata;
    if (KEEP_ENABLE) assign s_axis[KEEP_OFFSET +: KEEP_WIDTH] = s_axis_tkeep;
    if (LAST_ENABLE) assign s_axis[LAST_OFFSET]               = s_axis_tlast;
    if (ID_ENABLE)   assign s_axis[ID_OFFSET   +: ID_WIDTH]   = s_axis_tid;
    if (DEST_ENABLE) assign s_axis[DEST_OFFSET +: DEST_WIDTH] = s_axis_tdest;
    if (USER_ENABLE) assign s_axis[USER_OFFSET +: USER_WIDTH] = s_axis_tuser;
endgenerate

assign m_axis_tvalid = m_axis_tvalid_pipe_reg[PIPELINE_OUTPUT-1];

assign m_axis_tdata = m_axis_pipe_reg[PIPELINE_OUTPUT-1][DATA_WIDTH-1:0];
assign m_axis_tkeep = KEEP_ENABLE ? m_axis_pipe_reg[PIPELINE_OUTPUT-1][KEEP_OFFSET +: KEEP_WIDTH] : {KEEP_WIDTH{1'b1}};
assign m_axis_tlast = LAST_ENABLE ? m_axis_pipe_reg[PIPELINE_OUTPUT-1][LAST_OFFSET]               : 1'b1;
assign m_axis_tid   = ID_ENABLE   ? m_axis_pipe_reg[PIPELINE_OUTPUT-1][ID_OFFSET   +: ID_WIDTH]   : {ID_WIDTH{1'b0}};
assign m_axis_tdest = DEST_ENABLE ? m_axis_pipe_reg[PIPELINE_OUTPUT-1][DEST_OFFSET +: DEST_WIDTH] : {DEST_WIDTH{1'b0}};
assign m_axis_tuser = USER_ENABLE ? m_axis_pipe_reg[PIPELINE_OUTPUT-1][USER_OFFSET +: USER_WIDTH] : {USER_WIDTH{1'b0}};

assign s_status_overflow = overflow_reg;
assign s_status_bad_frame = bad_frame_reg;
assign s_status_good_frame = good_frame_reg;

assign m_status_overflow = overflow_sync3_reg ^ overflow_sync4_reg;
assign m_status_bad_frame = bad_frame_sync3_reg ^ bad_frame_sync4_reg;
assign m_status_good_frame = good_frame_sync3_reg ^ good_frame_sync4_reg;

always @(posedge s_clk or posedge async_rst) begin
    if (async_rst) begin
        s_rst_sync1_reg <= 1'b1;
        s_rst_sync2_reg <= 1'b1;
        s_rst_sync3_reg <= 1'b1;
    end else begin
        s_rst_sync1_reg <= 1'b0;
        s_rst_sync2_reg <= s_rst_sync1_reg || m_rst_sync1_reg;
        s_rst_sync3_reg <= s_rst_sync2_reg;
    end
end

always @(posedge m_clk or posedge async_rst) begin
    if (async_rst) begin
        m_rst_sync1_reg <= 1'b1;
        m_rst_sync2_reg <= 1'b1;
        m_rst_sync3_reg <= 1'b1;
    end else begin
        m_rst_sync1_reg <= 1'b0;
        m_rst_sync2_reg <= s_rst_sync1_reg || m_rst_sync1_reg;
        m_rst_sync3_reg <= m_rst_sync2_reg;
    end
end

always @(posedge s_clk) begin
    overflow_reg <= 1'b0;
    bad_frame_reg <= 1'b0;
    good_frame_reg <= 1'b0;

    if (FRAME_FIFO && wr_ptr_update_valid_reg) begin
        if (wr_ptr_update_reg == wr_ptr_update_ack_sync2_reg) begin
            wr_ptr_update_valid_reg <= 1'b0;
            wr_ptr_sync_gray_reg <= wr_ptr_gray_reg;
            wr_ptr_update_reg <= !wr_ptr_update_ack_sync2_reg;
        end
    end

    if (s_axis_tready && s_axis_tvalid) begin
        if (!FRAME_FIFO) begin
            mem[wr_ptr_reg[ADDR_WIDTH-1:0]] <= s_axis;
            wr_ptr_temp = wr_ptr_reg + 1;
            wr_ptr_reg <= wr_ptr_temp;
            wr_ptr_gray_reg <= wr_ptr_temp ^ (wr_ptr_temp >> 1);
        end else if (full_cur || full_wr || drop_frame_reg) begin
            drop_frame_reg <= 1'b1;
            if (s_axis_tlast) begin
                wr_ptr_temp = wr_ptr_reg;
                wr_ptr_cur_reg <= wr_ptr_temp;
                wr_ptr_cur_gray_reg <= wr_ptr_temp ^ (wr_ptr_temp >> 1);
                drop_frame_reg <= 1'b0;
                overflow_reg <= 1'b1;
            end
        end else begin
            mem[wr_ptr_cur_reg[ADDR_WIDTH-1:0]] <= s_axis;
            wr_ptr_temp = wr_ptr_cur_reg + 1;
            wr_ptr_cur_reg <= wr_ptr_temp;
            wr_ptr_cur_gray_reg <= wr_ptr_temp ^ (wr_ptr_temp >> 1);
            if (s_axis_tlast) begin
                if (DROP_BAD_FRAME && USER_BAD_FRAME_MASK & ~(s_axis_tuser ^ USER_BAD_FRAME_VALUE)) begin
                    wr_ptr_temp = wr_ptr_reg;
                    wr_ptr_cur_reg <= wr_ptr_temp;
                    wr_ptr_cur_gray_reg <= wr_ptr_temp ^ (wr_ptr_temp >> 1);
                    bad_frame_reg <= 1'b1;
                end else begin
                    wr_ptr_temp = wr_ptr_cur_reg + 1;
                    wr_ptr_reg <= wr_ptr_temp;
                    wr_ptr_gray_reg <= wr_ptr_temp ^ (wr_ptr_temp >> 1);

                    if (wr_ptr_update_reg == wr_ptr_update_ack_sync2_reg) begin
                        wr_ptr_update_valid_reg <= 1'b0;
                        wr_ptr_sync_gray_reg <= wr_ptr_temp ^ (wr_ptr_temp >> 1);
                        wr_ptr_update_reg <= !wr_ptr_update_ack_sync2_reg;
                    end else begin
                        wr_ptr_update_valid_reg <= 1'b1;
                    end

                    good_frame_reg <= 1'b1;
                end
            end
        end
    end

    if (s_rst_sync3_reg) begin
        wr_ptr_reg <= {ADDR_WIDTH+1{1'b0}};
        wr_ptr_cur_reg <= {ADDR_WIDTH+1{1'b0}};
        wr_ptr_gray_reg <= {ADDR_WIDTH+1{1'b0}};
        wr_ptr_sync_gray_reg <= {ADDR_WIDTH+1{1'b0}};
        wr_ptr_cur_gray_reg <= {ADDR_WIDTH+1{1'b0}};

        wr_ptr_update_valid_reg <= 1'b0;
        wr_ptr_update_reg <= 1'b0;

        drop_frame_reg <= 1'b0;
        overflow_reg <= 1'b0;
        bad_frame_reg <= 1'b0;
        good_frame_reg <= 1'b0;
    end
end

always @(posedge s_clk) begin
    rd_ptr_gray_sync1_reg <= rd_ptr_gray_reg;
    rd_ptr_gray_sync2_reg <= rd_ptr_gray_sync1_reg;
    wr_ptr_update_ack_sync1_reg <= wr_ptr_update_sync3_reg;
    wr_ptr_update_ack_sync2_reg <= wr_ptr_update_ack_sync1_reg;

    if (s_rst_sync3_reg) begin
        rd_ptr_gray_sync1_reg <= {ADDR_WIDTH+1{1'b0}};
        rd_ptr_gray_sync2_reg <= {ADDR_WIDTH+1{1'b0}};
        wr_ptr_update_ack_sync1_reg <= 1'b0;
        wr_ptr_update_ack_sync2_reg <= 1'b0;
    end
end

always @(posedge m_clk) begin
    if (!FRAME_FIFO) begin
        wr_ptr_gray_sync1_reg <= wr_ptr_gray_reg;
    end else if (wr_ptr_update_sync2_reg ^ wr_ptr_update_sync3_reg) begin
        wr_ptr_gray_sync1_reg <= wr_ptr_sync_gray_reg;
    end
    wr_ptr_gray_sync2_reg <= wr_ptr_gray_sync1_reg;
    wr_ptr_update_sync1_reg <= wr_ptr_update_reg;
    wr_ptr_update_sync2_reg <= wr_ptr_update_sync1_reg;
    wr_ptr_update_sync3_reg <= wr_ptr_update_sync2_reg;

    if (m_rst_sync3_reg) begin
        wr_ptr_gray_sync1_reg <= {ADDR_WIDTH+1{1'b0}};
        wr_ptr_gray_sync2_reg <= {ADDR_WIDTH+1{1'b0}};
        wr_ptr_update_sync1_reg <= 1'b0;
        wr_ptr_update_sync2_reg <= 1'b0;
        wr_ptr_update_sync3_reg <= 1'b0;
    end
end

always @(posedge s_clk) begin
    overflow_sync1_reg <= overflow_sync1_reg ^ overflow_reg;
    bad_frame_sync1_reg <= bad_frame_sync1_reg ^ bad_frame_reg;
    good_frame_sync1_reg <= good_frame_sync1_reg ^ good_frame_reg;

    if (s_rst_sync3_reg) begin
        overflow_sync1_reg <= 1'b0;
        bad_frame_sync1_reg <= 1'b0;
        good_frame_sync1_reg <= 1'b0;
    end
end

always @(posedge m_clk) begin
    overflow_sync2_reg <= overflow_sync1_reg;
    overflow_sync3_reg <= overflow_sync2_reg;
    overflow_sync4_reg <= overflow_sync3_reg;
    bad_frame_sync2_reg <= bad_frame_sync1_reg;
    bad_frame_sync3_reg <= bad_frame_sync2_reg;
    bad_frame_sync4_reg <= bad_frame_sync3_reg;
    good_frame_sync2_reg <= good_frame_sync1_reg;
    good_frame_sync3_reg <= good_frame_sync2_reg;
    good_frame_sync4_reg <= good_frame_sync3_reg;

    if (m_rst_sync3_reg) begin
        overflow_sync2_reg <= 1'b0;
        overflow_sync3_reg <= 1'b0;
        overflow_sync4_reg <= 1'b0;
        bad_frame_sync2_reg <= 1'b0;
        bad_frame_sync3_reg <= 1'b0;
        bad_frame_sync4_reg <= 1'b0;
        good_frame_sync2_reg <= 1'b0;
        good_frame_sync3_reg <= 1'b0;
        good_frame_sync4_reg <= 1'b0;
    end
end

integer j;

always @(posedge m_clk) begin
    if (m_axis_tready) begin
        m_axis_tvalid_pipe_reg[PIPELINE_OUTPUT-1] <= 1'b0;
    end

    for (j = PIPELINE_OUTPUT-1; j > 0; j = j - 1) begin
        if (m_axis_tready || ((~m_axis_tvalid_pipe_reg) >> j)) begin
            m_axis_tvalid_pipe_reg[j] <= m_axis_tvalid_pipe_reg[j-1];
            m_axis_pipe_reg[j] <= m_axis_pipe_reg[j-1];
            m_axis_tvalid_pipe_reg[j-1] <= 1'b0;
        end
    end

    if (m_axis_tready || ~m_axis_tvalid_pipe_reg) begin
        m_axis_tvalid_pipe_reg[0] <= 1'b0;
        m_axis_pipe_reg[0] <= mem[rd_ptr_reg[ADDR_WIDTH-1:0]];
        if (!empty) begin
            m_axis_tvalid_pipe_reg[0] <= 1'b1;
            rd_ptr_temp = rd_ptr_reg + 1;
            rd_ptr_reg <= rd_ptr_temp;
            rd_ptr_gray_reg <= rd_ptr_temp ^ (rd_ptr_temp >> 1);
        end
    end

    if (m_rst_sync3_reg) begin
        rd_ptr_reg <= {ADDR_WIDTH+1{1'b0}};
        rd_ptr_gray_reg <= {ADDR_WIDTH+1{1'b0}};
        m_axis_tvalid_pipe_reg <= {PIPELINE_OUTPUT{1'b0}};
    end
end

endmodule