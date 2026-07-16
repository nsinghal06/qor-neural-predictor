//1236
module axis_infrastructure_v1_1_util_aclken_converter # (
parameter integer C_PAYLOAD_WIDTH       = 32,
  parameter integer C_S_ACLKEN_CAN_TOGGLE = 1,
  parameter integer C_M_ACLKEN_CAN_TOGGLE = 1
  )
 (
input  wire                        ACLK,
  input  wire                        ARESETN,

  input  wire                        S_ACLKEN,
  input  wire [C_PAYLOAD_WIDTH-1:0]  S_PAYLOAD,
  input  wire                        S_VALID,
  output wire                        S_READY,

  input  wire                        M_ACLKEN,
  output wire [C_PAYLOAD_WIDTH-1:0]  M_PAYLOAD,
  output wire                        M_VALID,
  input  wire                        M_READY
);

localparam SM_NOT_READY    = 3'b000;
localparam SM_EMPTY        = 3'b001;
localparam SM_R0_NOT_READY = 3'b010;
localparam SM_R0           = 3'b011;
localparam SM_R1           = 3'b100;
localparam SM_FULL         = 3'b110;

wire s_aclken_i;
wire m_aclken_i;
reg  areset;

reg [2:0] state;

reg [C_PAYLOAD_WIDTH-1:0] r0;
wire                      load_r0;
wire                      load_r0_from_r1;

reg [C_PAYLOAD_WIDTH-1:0] r1;
wire                      load_r1;
assign s_aclken_i = C_S_ACLKEN_CAN_TOGGLE ? S_ACLKEN : 1'b1;
assign m_aclken_i = C_M_ACLKEN_CAN_TOGGLE ? M_ACLKEN : 1'b1;

always @(posedge ACLK) begin 
  areset <= ~ARESETN;
end

assign S_READY = state[0];
assign M_VALID = state[1];

always @(posedge ACLK) begin 
  if (areset) begin
    state <= SM_NOT_READY;
  end
  else begin 
    case (state)
      SM_NOT_READY: begin
        if (s_aclken_i) begin
          state <= SM_EMPTY;
        end
        else begin
          state <= state;
        end
      end

      SM_EMPTY: begin
        if (s_aclken_i & S_VALID & m_aclken_i) begin
          state <= SM_R0;
        end
        else if (s_aclken_i & S_VALID & ~m_aclken_i) begin
          state <= SM_R1;
        end
        else begin 
          state <= state;
        end
      end

      SM_R0: begin
        if ((m_aclken_i & M_READY) & ~(s_aclken_i & S_VALID)) begin
          state <= SM_EMPTY;
        end
        else if (~(m_aclken_i & M_READY) & (s_aclken_i & S_VALID)) begin
          state <= SM_FULL;
        end
        else begin 
          state <= state;
        end
      end

      SM_R0_NOT_READY: begin
        if (s_aclken_i & m_aclken_i & M_READY) begin
          state <= SM_EMPTY;
        end
        else if (~s_aclken_i & m_aclken_i & M_READY) begin
          state <= SM_NOT_READY;
        end
        else if (s_aclken_i) begin
          state <= SM_R0;
        end
        else begin 
          state <= state;
        end
      end

      SM_R1: begin
        if (~s_aclken_i & m_aclken_i) begin
          state <= SM_R0_NOT_READY;
        end
        else if (s_aclken_i & m_aclken_i) begin 
          state <= SM_R0;
        end
        else begin 
          state <= state;
        end
      end

      SM_FULL: begin
        if (~s_aclken_i & m_aclken_i & M_READY) begin
          state <= SM_R0_NOT_READY;
        end
        else if (s_aclken_i & m_aclken_i & M_READY) begin 
          state <= SM_R0;
        end
        else begin 
          state <= state;
        end
      end

      default: begin
        state <= SM_NOT_READY;
      end
    endcase
  end
end

assign M_PAYLOAD = r0;

always @(posedge ACLK) begin
  if (m_aclken_i) begin 
    r0 <= ~load_r0 ? r0 :
          load_r0_from_r1 ? r1 :
          S_PAYLOAD ;
  end
end

assign load_r0 = (state == SM_EMPTY) 
                 | (state == SM_R1) 
                 | ((state == SM_R0) & M_READY)
                 | ((state == SM_FULL) & M_READY);

assign load_r0_from_r1 = (state == SM_R1) | (state == SM_FULL);

always @(posedge ACLK) begin
  r1 <= ~load_r1 ? r1 : S_PAYLOAD;
end

assign load_r1 = (state == SM_EMPTY) | (state == SM_R0);


endmodule