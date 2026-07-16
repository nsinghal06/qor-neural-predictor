//1447
module axis_adapter #
(
    parameter S_DATA_WIDTH = 8,
    parameter S_KEEP_ENABLE = (S_DATA_WIDTH>8),
    parameter S_KEEP_WIDTH = (S_DATA_WIDTH/8),
    parameter M_DATA_WIDTH = 8,
    parameter M_KEEP_ENABLE = (M_DATA_WIDTH>8),
    parameter M_KEEP_WIDTH = (M_DATA_WIDTH/8),
    parameter ID_ENABLE = 0,
    parameter ID_WIDTH = 8,
    parameter DEST_ENABLE = 0,
    parameter DEST_WIDTH = 8,
    parameter USER_ENABLE = 1,
    parameter USER_WIDTH = 1
)
(
    input  wire                     clk,
    input  wire                     rst,

    
    input  wire [S_DATA_WIDTH-1:0]  s_axis_tdata,
    input  wire [S_KEEP_WIDTH-1:0]  s_axis_tkeep,
    input  wire                     s_axis_tvalid,
    output wire                     s_axis_tready,
    input  wire                     s_axis_tlast,
    input  wire [ID_WIDTH-1:0]      s_axis_tid,
    input  wire [DEST_WIDTH-1:0]    s_axis_tdest,
    input  wire [USER_WIDTH-1:0]    s_axis_tuser,

    
    output wire [M_DATA_WIDTH-1:0]  m_axis_tdata,
    output wire [M_KEEP_WIDTH-1:0]  m_axis_tkeep,
    output wire                     m_axis_tvalid,
    input  wire                     m_axis_tready,
    output wire                     m_axis_tlast,
    output wire [ID_WIDTH-1:0]      m_axis_tid,
    output wire [DEST_WIDTH-1:0]    m_axis_tdest,
    output wire [USER_WIDTH-1:0]    m_axis_tuser
);

parameter S_KEEP_WIDTH_INT = S_KEEP_ENABLE ? S_KEEP_WIDTH : 1;
parameter M_KEEP_WIDTH_INT = M_KEEP_ENABLE ? M_KEEP_WIDTH : 1;

parameter S_DATA_WORD_SIZE = S_DATA_WIDTH / S_KEEP_WIDTH_INT;
parameter M_DATA_WORD_SIZE = M_DATA_WIDTH / M_KEEP_WIDTH_INT;
parameter EXPAND_BUS = M_KEEP_WIDTH_INT > S_KEEP_WIDTH_INT;
parameter DATA_WIDTH = EXPAND_BUS ? M_DATA_WIDTH : S_DATA_WIDTH;
parameter KEEP_WIDTH = EXPAND_BUS ? M_KEEP_WIDTH_INT : S_KEEP_WIDTH_INT;
parameter SEGMENT_COUNT = EXPAND_BUS ? (M_KEEP_WIDTH_INT / S_KEEP_WIDTH_INT) : (S_KEEP_WIDTH_INT / M_KEEP_WIDTH_INT);
parameter SEGMENT_COUNT_WIDTH = SEGMENT_COUNT == 1 ? 1 : $clog2(SEGMENT_COUNT);
parameter SEGMENT_DATA_WIDTH = DATA_WIDTH / SEGMENT_COUNT;
parameter SEGMENT_KEEP_WIDTH = KEEP_WIDTH / SEGMENT_COUNT;

initial begin
    if (S_DATA_WORD_SIZE * S_KEEP_WIDTH_INT != S_DATA_WIDTH) begin
        $error("Error: input data width not evenly divisble (instance %m)");
        $finish;
    end

    if (M_DATA_WORD_SIZE * M_KEEP_WIDTH_INT != M_DATA_WIDTH) begin
        $error("Error: output data width not evenly divisble (instance %m)");
        $finish;
    end

    if (S_DATA_WORD_SIZE != M_DATA_WORD_SIZE) begin
        $error("Error: word size mismatch (instance %m)");
        $finish;
    end
end

localparam [2:0]
    STATE_IDLE = 3'd0,
    STATE_TRANSFER_IN = 3'd1,
    STATE_TRANSFER_OUT = 3'd2;

reg [2:0] state_reg = STATE_IDLE, state_next;

reg [SEGMENT_COUNT_WIDTH-1:0] segment_count_reg = 0, segment_count_next;

reg last_segment;

reg [DATA_WIDTH-1:0] temp_tdata_reg = {DATA_WIDTH{1'b0}}, temp_tdata_next;
reg [KEEP_WIDTH-1:0] temp_tkeep_reg = {KEEP_WIDTH{1'b0}}, temp_tkeep_next;
reg                  temp_tlast_reg = 1'b0, temp_tlast_next;
reg [ID_WIDTH-1:0]   temp_tid_reg   = {ID_WIDTH{1'b0}}, temp_tid_next;
reg [DEST_WIDTH-1:0] temp_tdest_reg = {DEST_WIDTH{1'b0}}, temp_tdest_next;
reg [USER_WIDTH-1:0] temp_tuser_reg = {USER_WIDTH{1'b0}}, temp_tuser_next;

reg  [M_DATA_WIDTH-1:0] m_axis_tdata_int;
reg  [M_KEEP_WIDTH-1:0] m_axis_tkeep_int;
reg                     m_axis_tvalid_int;
reg                     m_axis_tready_int_reg = 1'b0;
reg                     m_axis_tlast_int;
reg  [ID_WIDTH-1:0]     m_axis_tid_int;
reg  [DEST_WIDTH-1:0]   m_axis_tdest_int;
reg  [USER_WIDTH-1:0]   m_axis_tuser_int;
wire                    m_axis_tready_int_early;

reg s_axis_tready_reg = 1'b0, s_axis_tready_next;

assign s_axis_tready = s_axis_tready_reg;

always @* begin
    state_next = STATE_IDLE;

    segment_count_next = segment_count_reg;

    last_segment = 0;

    temp_tdata_next = temp_tdata_reg;
    temp_tkeep_next = temp_tkeep_reg;
    temp_tlast_next = temp_tlast_reg;
    temp_tid_next   = temp_tid_reg;
    temp_tdest_next = temp_tdest_reg;
    temp_tuser_next = temp_tuser_reg;

    if (EXPAND_BUS) begin
        m_axis_tdata_int  = temp_tdata_reg;
        m_axis_tkeep_int  = temp_tkeep_reg;
        m_axis_tlast_int  = temp_tlast_reg;
    end else begin
        m_axis_tdata_int  = {M_DATA_WIDTH{1'b0}};
        m_axis_tkeep_int  = {M_KEEP_WIDTH{1'b0}};
        m_axis_tlast_int  = 1'b0;
    end
    m_axis_tvalid_int = 1'b0;
    m_axis_tid_int    = temp_tid_reg;
    m_axis_tdest_int  = temp_tdest_reg;
    m_axis_tuser_int  = temp_tuser_reg;

    s_axis_tready_next = 1'b0;

    case (state_reg)
        STATE_IDLE: begin
            if (SEGMENT_COUNT == 1) begin
                s_axis_tready_next = m_axis_tready_int_early;

                m_axis_tdata_int  = s_axis_tdata;
                m_axis_tkeep_int  = S_KEEP_ENABLE ? s_axis_tkeep : 1'b1;
                m_axis_tvalid_int = s_axis_tvalid;
                m_axis_tlast_int  = s_axis_tlast;
                m_axis_tid_int    = s_axis_tid;
                m_axis_tdest_int  = s_axis_tdest;
                m_axis_tuser_int  = s_axis_tuser;

                state_next = STATE_IDLE;
            end else if (EXPAND_BUS) begin
                s_axis_tready_next = 1'b1;

                if (s_axis_tready && s_axis_tvalid) begin
                    temp_tdata_next = s_axis_tdata;
                    temp_tkeep_next = S_KEEP_ENABLE ? s_axis_tkeep : 1'b1;
                    temp_tlast_next = s_axis_tlast;
                    temp_tid_next   = s_axis_tid;
                    temp_tdest_next = s_axis_tdest;
                    temp_tuser_next = s_axis_tuser;

                    segment_count_next = 1;

                    if (s_axis_tlast) begin
                        s_axis_tready_next = 1'b0;
                        state_next = STATE_TRANSFER_OUT;
                    end else begin
                        s_axis_tready_next = 1'b1;
                        state_next = STATE_TRANSFER_IN;
                    end
                end else begin
                    state_next = STATE_IDLE;
                end
            end else begin
                s_axis_tready_next = 1'b1;

                if (s_axis_tready && s_axis_tvalid) begin
                    segment_count_next = 0;

                    if (SEGMENT_COUNT == 1) begin
                        last_segment = 1'b1;
                    end else if (S_KEEP_ENABLE && s_axis_tkeep[SEGMENT_KEEP_WIDTH-1:0] != {SEGMENT_KEEP_WIDTH{1'b1}}) begin
                        last_segment = 1'b1;
                    end else if (S_KEEP_ENABLE && s_axis_tkeep[(SEGMENT_KEEP_WIDTH*2)-1:SEGMENT_KEEP_WIDTH] == {SEGMENT_KEEP_WIDTH{1'b0}}) begin
                        last_segment = 1'b1;
                    end else begin
                        last_segment = 1'b0;
                    end

                    temp_tdata_next = s_axis_tdata;
                    temp_tkeep_next = S_KEEP_ENABLE ? s_axis_tkeep : 1'b1;
                    temp_tlast_next = s_axis_tlast;
                    temp_tid_next   = s_axis_tid;
                    temp_tdest_next = s_axis_tdest;
                    temp_tuser_next = s_axis_tuser;

                    m_axis_tdata_int  = s_axis_tdata[SEGMENT_DATA_WIDTH-1:0];
                    m_axis_tkeep_int  = s_axis_tkeep[SEGMENT_KEEP_WIDTH-1:0];
                    m_axis_tvalid_int = 1'b1;
                    m_axis_tlast_int  = s_axis_tlast & last_segment;
                    m_axis_tid_int    = s_axis_tid;
                    m_axis_tdest_int  = s_axis_tdest;
                    m_axis_tuser_int  = s_axis_tuser;

                    if (m_axis_tready_int_reg) begin
                        segment_count_next = 1;
                    end

                    if (!last_segment || !m_axis_tready_int_reg) begin
                        s_axis_tready_next = 1'b0;
                        state_next = STATE_TRANSFER_OUT;
                    end else begin
                        state_next = STATE_IDLE;
                    end
                end else begin
                    state_next = STATE_IDLE;
                end
            end
        end
        STATE_TRANSFER_IN: begin
            s_axis_tready_next = 1'b1;

            if (s_axis_tready && s_axis_tvalid) begin
                temp_tdata_next[segment_count_reg*SEGMENT_DATA_WIDTH +: SEGMENT_DATA_WIDTH] = s_axis_tdata;
                temp_tkeep_next[segment_count_reg*SEGMENT_KEEP_WIDTH +: SEGMENT_KEEP_WIDTH] = S_KEEP_ENABLE ? s_axis_tkeep : 1'b1;
                temp_tlast_next = s_axis_tlast;
                temp_tid_next   = s_axis_tid;
                temp_tdest_next = s_axis_tdest;
                temp_tuser_next = s_axis_tuser;

                segment_count_next = segment_count_reg + 1;

                if ((segment_count_reg == SEGMENT_COUNT-1) || s_axis_tlast) begin
                    s_axis_tready_next = m_axis_tready_int_early;
                    state_next = STATE_TRANSFER_OUT;
                end else begin
                    s_axis_tready_next = 1'b1;
                    state_next = STATE_TRANSFER_IN;
                end
            end else begin
                state_next = STATE_TRANSFER_IN;
            end
        end
        STATE_TRANSFER_OUT: begin
            if (EXPAND_BUS) begin
                s_axis_tready_next = 1'b0;

                m_axis_tdata_int  = temp_tdata_reg;
                m_axis_tkeep_int  = temp_tkeep_reg;
                m_axis_tvalid_int = 1'b1;
                m_axis_tlast_int  = temp_tlast_reg;
                m_axis_tid_int    = temp_tid_reg;
                m_axis_tdest_int  = temp_tdest_reg;
                m_axis_tuser_int  = temp_tuser_reg;

                if (m_axis_tready_int_reg) begin
                    if (s_axis_tready && s_axis_tvalid) begin
                        temp_tdata_next = s_axis_tdata;
                        temp_tkeep_next = S_KEEP_ENABLE ? s_axis_tkeep : 1'b1;
                        temp_tlast_next = s_axis_tlast;
                        temp_tid_next   = s_axis_tid;
                        temp_tdest_next = s_axis_tdest;
                        temp_tuser_next = s_axis_tuser;

                        segment_count_next = 1;

                        if (s_axis_tlast) begin
                            s_axis_tready_next = 1'b0;
                            state_next = STATE_TRANSFER_OUT;
                        end else begin
                            s_axis_tready_next = 1'b1;
                            state_next = STATE_TRANSFER_IN;
                        end
                    end else begin
                        s_axis_tready_next = 1'b1;
                        state_next = STATE_IDLE;
                    end
                end else begin
                    state_next = STATE_TRANSFER_OUT;
                end
            end else begin
                s_axis_tready_next = 1'b0;

                if (segment_count_reg == SEGMENT_COUNT-1) begin
                    last_segment = 1'b1;
                end else if (temp_tkeep_reg[segment_count_reg*SEGMENT_KEEP_WIDTH +: SEGMENT_KEEP_WIDTH] != {SEGMENT_KEEP_WIDTH{1'b1}}) begin
                    last_segment = 1'b1;
                end else if (temp_tkeep_reg[(segment_count_reg+1)*SEGMENT_KEEP_WIDTH +: SEGMENT_KEEP_WIDTH] == {SEGMENT_KEEP_WIDTH{1'b0}}) begin
                    last_segment = 1'b1;
                end else begin
                    last_segment = 1'b0;
                end

                m_axis_tdata_int  = temp_tdata_reg[segment_count_reg*SEGMENT_DATA_WIDTH +: SEGMENT_DATA_WIDTH];
                m_axis_tkeep_int  = temp_tkeep_reg[segment_count_reg*SEGMENT_KEEP_WIDTH +: SEGMENT_KEEP_WIDTH];
                m_axis_tvalid_int = 1'b1;
                m_axis_tlast_int  = temp_tlast_reg && last_segment;
                m_axis_tid_int    = temp_tid_reg;
                m_axis_tdest_int  = temp_tdest_reg;
                m_axis_tuser_int  = temp_tuser_reg;

                if (m_axis_tready_int_reg) begin
                    segment_count_next = segment_count_reg + 1;

                    if (last_segment) begin
                        s_axis_tready_next = 1'b1;
                        state_next = STATE_IDLE;
                    end else begin
                        state_next = STATE_TRANSFER_OUT;
                    end
                end else begin
                    state_next = STATE_TRANSFER_OUT;
                end
            end
        end
    endcase
end

always @(posedge clk) begin
    if (rst) begin
        state_reg <= STATE_IDLE;
        s_axis_tready_reg <= 1'b0;
    end else begin
        state_reg <= state_next;

        s_axis_tready_reg <= s_axis_tready_next;
    end

    segment_count_reg <= segment_count_next;

    temp_tdata_reg <= temp_tdata_next;
    temp_tkeep_reg <= temp_tkeep_next;
    temp_tlast_reg <= temp_tlast_next;
    temp_tid_reg   <= temp_tid_next;
    temp_tdest_reg <= temp_tdest_next;
    temp_tuser_reg <= temp_tuser_next;
end

reg [M_DATA_WIDTH-1:0] m_axis_tdata_reg  = {M_DATA_WIDTH{1'b0}};
reg [M_KEEP_WIDTH-1:0] m_axis_tkeep_reg  = {M_KEEP_WIDTH{1'b0}};
reg                    m_axis_tvalid_reg = 1'b0, m_axis_tvalid_next;
reg                    m_axis_tlast_reg  = 1'b0;
reg [ID_WIDTH-1:0]     m_axis_tid_reg    = {ID_WIDTH{1'b0}};
reg [DEST_WIDTH-1:0]   m_axis_tdest_reg  = {DEST_WIDTH{1'b0}};
reg [USER_WIDTH-1:0]   m_axis_tuser_reg  = {USER_WIDTH{1'b0}};

reg [M_DATA_WIDTH-1:0] temp_m_axis_tdata_reg  = {M_DATA_WIDTH{1'b0}};
reg [M_KEEP_WIDTH-1:0] temp_m_axis_tkeep_reg  = {M_KEEP_WIDTH{1'b0}};
reg                    temp_m_axis_tvalid_reg = 1'b0, temp_m_axis_tvalid_next;
reg                    temp_m_axis_tlast_reg  = 1'b0;
reg [ID_WIDTH-1:0]     temp_m_axis_tid_reg    = {ID_WIDTH{1'b0}};
reg [DEST_WIDTH-1:0]   temp_m_axis_tdest_reg  = {DEST_WIDTH{1'b0}};
reg [USER_WIDTH-1:0]   temp_m_axis_tuser_reg  = {USER_WIDTH{1'b0}};

reg store_axis_int_to_output;
reg store_axis_int_to_temp;
reg store_axis_temp_to_output;

assign m_axis_tdata  = m_axis_tdata_reg;
assign m_axis_tkeep  = M_KEEP_ENABLE ? m_axis_tkeep_reg : {M_KEEP_WIDTH{1'b1}};
assign m_axis_tvalid = m_axis_tvalid_reg;
assign m_axis_tlast  = m_axis_tlast_reg;
assign m_axis_tid    = ID_ENABLE   ? m_axis_tid_reg   : {ID_WIDTH{1'b0}};
assign m_axis_tdest  = DEST_ENABLE ? m_axis_tdest_reg : {DEST_WIDTH{1'b0}};
assign m_axis_tuser  = USER_ENABLE ? m_axis_tuser_reg : {USER_WIDTH{1'b0}};

assign m_axis_tready_int_early = m_axis_tready || (!temp_m_axis_tvalid_reg && (!m_axis_tvalid_reg || !m_axis_tvalid_int));

always @* begin
    m_axis_tvalid_next = m_axis_tvalid_reg;
    temp_m_axis_tvalid_next = temp_m_axis_tvalid_reg;

    store_axis_int_to_output = 1'b0;
    store_axis_int_to_temp = 1'b0;
    store_axis_temp_to_output = 1'b0;

    if (m_axis_tready_int_reg) begin
        if (m_axis_tready || !m_axis_tvalid_reg) begin
            m_axis_tvalid_next = m_axis_tvalid_int;
            store_axis_int_to_output = 1'b1;
        end else begin
            temp_m_axis_tvalid_next = m_axis_tvalid_int;
            store_axis_int_to_temp = 1'b1;
        end
    end else if (m_axis_tready) begin
        m_axis_tvalid_next = temp_m_axis_tvalid_reg;
        temp_m_axis_tvalid_next = 1'b0;
        store_axis_temp_to_output = 1'b1;
    end
end

always @(posedge clk) begin
    if (rst) begin
        m_axis_tvalid_reg <= 1'b0;
        m_axis_tready_int_reg <= 1'b0;
        temp_m_axis_tvalid_reg <= 1'b0;
    end else begin
        m_axis_tvalid_reg <= m_axis_tvalid_next;
        m_axis_tready_int_reg <= m_axis_tready_int_early;
        temp_m_axis_tvalid_reg <= temp_m_axis_tvalid_next;
    end

    if (store_axis_int_to_output) begin
        m_axis_tdata_reg <= m_axis_tdata_int;
        m_axis_tkeep_reg <= m_axis_tkeep_int;
        m_axis_tlast_reg <= m_axis_tlast_int;
        m_axis_tid_reg   <= m_axis_tid_int;
        m_axis_tdest_reg <= m_axis_tdest_int;
        m_axis_tuser_reg <= m_axis_tuser_int;
    end else if (store_axis_temp_to_output) begin
        m_axis_tdata_reg <= temp_m_axis_tdata_reg;
        m_axis_tkeep_reg <= temp_m_axis_tkeep_reg;
        m_axis_tlast_reg <= temp_m_axis_tlast_reg;
        m_axis_tid_reg   <= temp_m_axis_tid_reg;
        m_axis_tdest_reg <= temp_m_axis_tdest_reg;
        m_axis_tuser_reg <= temp_m_axis_tuser_reg;
    end

    if (store_axis_int_to_temp) begin
        temp_m_axis_tdata_reg <= m_axis_tdata_int;
        temp_m_axis_tkeep_reg <= m_axis_tkeep_int;
        temp_m_axis_tlast_reg <= m_axis_tlast_int;
        temp_m_axis_tid_reg   <= m_axis_tid_int;
        temp_m_axis_tdest_reg <= m_axis_tdest_int;
        temp_m_axis_tuser_reg <= m_axis_tuser_int;
    end
end

endmodule