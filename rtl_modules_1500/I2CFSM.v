//589
module I2CFSM (
  input                  Reset_n_i,
  input                  Clk_i,
  input                  QueryLocal_i,
  input                  QueryRemote_i,
  output reg             Done_o,
  output reg             Error_o,
  output reg [7:0]       Byte0_o,
  output reg [7:0]       Byte1_o,
  output reg             I2C_ReceiveSend_n_o,
  output reg [7:0]       I2C_ReadCount_o,
  output reg             I2C_StartProcess_o,
  input                  I2C_Busy_i,
  output reg             I2C_FIFOReadNext_o,
  output reg             I2C_FIFOWrite_o,
  output reg [7:0]       I2C_Data_o,
  input      [7:0]       I2C_Data_i,
  input                  I2C_Error_i
);

  localparam stIdle            = 4'd0;
  localparam stReqLocWrPtr     = 4'd1;   localparam stReqLocStart     = 4'd2;
  localparam stReqLocWait      = 4'd3;
  localparam stReqRemWrPtr     = 4'd4;   localparam stReqRemStart     = 4'd5;
  localparam stReqRemWait      = 4'd6;
  localparam stReadWrRdAddr    = 4'd7;   localparam stRead            = 4'd8;
  localparam stReadStart       = 4'd9;
  localparam stReadWait        = 4'd10;
  localparam stReadStoreLSB    = 4'd11;
  localparam stPause           = 4'd12;
  reg  [3:0]             I2C_FSM_State;
  reg  [3:0]             I2C_FSM_NextState;
  wire                   I2C_FSM_TimerOvfl;
  reg                    I2C_FSM_TimerPreset;
  reg                    I2C_FSM_TimerEnable;
  reg                    I2C_FSM_Wr1;
  reg                    I2C_FSM_Wr0;

  always @(negedge Reset_n_i or posedge Clk_i)
  begin
    if (!Reset_n_i)
    begin
      I2C_FSM_State <= stIdle;
    end
    else
    begin
      I2C_FSM_State <= I2C_FSM_NextState;
    end  
  end

  always @(I2C_FSM_State, QueryLocal_i, QueryRemote_i, I2C_Busy_i, I2C_Error_i, I2C_FSM_TimerOvfl)
  begin  I2C_FSM_NextState = I2C_FSM_State;
    Done_o              = 1'b0;
    Error_o             = 1'b0;
    I2C_ReceiveSend_n_o = 1'b0;
    I2C_ReadCount_o     = 8'h00;
    I2C_StartProcess_o  = 1'b0;
    I2C_FIFOReadNext_o  = 1'b0; 
    I2C_FIFOWrite_o     = 1'b0; 
    I2C_Data_o          = 8'h00;
    I2C_FSM_TimerPreset = 1'b1;
    I2C_FSM_TimerEnable = 1'b0;
    I2C_FSM_Wr1         = 1'b0;
    I2C_FSM_Wr0         = 1'b0;
    case (I2C_FSM_State)
      stIdle: begin
        if (QueryLocal_i == 1'b1)
        begin
          I2C_FSM_NextState = stReqLocWrPtr;
          I2C_Data_o        = 8'b10011000;
          I2C_FIFOWrite_o   = 1'b1;
        end
        else if (QueryRemote_i == 1'b1)
        begin
          I2C_FSM_NextState = stReqRemWrPtr;
          I2C_Data_o        = 8'b10011000;
          I2C_FIFOWrite_o   = 1'b1;
        end
        else
        begin
          I2C_Data_o        = 8'b10011000;
        end
      end
      stReqLocWrPtr: begin
        I2C_FSM_NextState   = stReqLocStart;
        I2C_Data_o          = 8'b00000000;
        I2C_FIFOWrite_o     = 1'b1;
      end
      stReqLocStart: begin
        I2C_StartProcess_o  = 1'b1;
        I2C_FSM_NextState   = stReqLocWait;
      end
      stReqLocWait: begin
        if (I2C_Error_i == 1'b1)
        begin
          I2C_FSM_NextState   = stIdle;
          Error_o             = 1'b1;
        end
        else if (I2C_Busy_i == 1'b0)
        begin
          I2C_FSM_NextState   = stRead;
        end
      end
      stReqRemWrPtr: begin
        I2C_FSM_NextState   = stReqRemStart;
        I2C_Data_o          = 8'b00000001;
        I2C_FIFOWrite_o     = 1'b1;
      end
      stReqRemStart: begin
        I2C_StartProcess_o  = 1'b1;
        I2C_FSM_NextState   = stReqRemWait;
      end
      stReqRemWait: begin
        if (I2C_Error_i == 1'b1)
        begin
          I2C_FSM_NextState   = stIdle;
          Error_o             = 1'b1;
        end
        else if (I2C_Busy_i == 1'b0)
        begin
          I2C_FSM_NextState   = stRead;
        end
      end
      stRead: begin
        I2C_FSM_NextState   = stReadStart;
        I2C_Data_o          = 8'b10011001;
        I2C_FIFOWrite_o     = 1'b1;
      end
      stReadStart: begin
        I2C_ReceiveSend_n_o = 1'b1;
        I2C_ReadCount_o     = 8'h02;
        I2C_StartProcess_o  = 1'b1;
        I2C_FSM_NextState   = stReadWait;
      end
      stReadWait: begin
        I2C_ReceiveSend_n_o = 1'b1;
        I2C_ReadCount_o     = 8'h02;
        if (I2C_Busy_i == 1'b0)
        begin
          I2C_FSM_NextState   = stReadStoreLSB;
          I2C_FIFOReadNext_o  = 1'b1;
          I2C_FSM_Wr1         = 1'b1;
        end
      end
      stReadStoreLSB: begin
        I2C_FIFOReadNext_o  = 1'b1;
        I2C_FSM_Wr0         = 1'b1;
        I2C_FSM_NextState   = stPause;
      end
      stPause: begin
        Done_o              = 1'b1;
        I2C_FSM_NextState   = stIdle;
      end
      default: begin
      end
    endcase
  end

  always @(negedge Reset_n_i or posedge Clk_i)
  begin
    if (!Reset_n_i)
    begin
      Byte0_o <= 8'd0;
      Byte1_o <= 8'd0;
    end
    else
    begin
      if (I2C_FSM_Wr0)
      begin
        Byte0_o <= I2C_Data_i;
      end
      if (I2C_FSM_Wr1)
      begin
        Byte1_o <= I2C_Data_i;
      end
    end  
  end

endmodule