//101
module clock_gen (
                  clk,
                  reset,
                  frequency,
                  clk_out
                  );

parameter DDS_PRESCALE_NDIV_PP = 5;    parameter DDS_PRESCALE_BITS_PP = 3;
parameter DDS_BITS_PP  = 6;

input clk;
input reset;
input[DDS_BITS_PP-2:0] frequency;
output clk_out;

wire pulse;
wire dds_clk;

wire [DDS_BITS_PP-2:0] dds_phase_increment = frequency; 

reg delayed_pulse;
reg [DDS_PRESCALE_BITS_PP-1:0] dds_prescale_count;
reg [DDS_BITS_PP-1:0] dds_phase;


always @(posedge clk)
begin
  if (reset) dds_prescale_count <= 0;
  else if (dds_prescale_count == (DDS_PRESCALE_NDIV_PP-1))
    dds_prescale_count <= 0;
  else dds_prescale_count <= dds_prescale_count + 1;
end
assign dds_clk = (dds_prescale_count == (DDS_PRESCALE_NDIV_PP-1));
always @(posedge clk)
begin
  if (reset) dds_phase <= 0;
  else if (dds_clk) dds_phase <= dds_phase + dds_phase_increment;
end

assign pulse = dds_phase[DDS_BITS_PP-1]; always @(posedge clk)
begin
  delayed_pulse <= pulse;
end
assign clk_out = (pulse && ~delayed_pulse);  endmodule

module clock_gen_select (
                         clk,
                         reset,
                         rate_select,
                         clk_out
                         );

input clk;
input reset;
input [2:0] rate_select;

output clk_out;

wire pulse;
wire dds_clk;

reg delayed_pulse;
reg [`DDS_PRESCALE_BITS-1:0] dds_prescale_count;
reg [`DDS_PRESCALE_BITS-1:0] dds_prescale_ndiv;
reg [`DDS_BITS-1:0] dds_phase;
reg [`DDS_BITS-2:0] dds_phase_increment;

always @(rate_select)
begin
  case (rate_select)
    3'b000  : begin
                dds_phase_increment <=  1;  dds_prescale_ndiv   <=  5;
              end
              
    3'b001  : begin
                dds_phase_increment <=  2;  dds_prescale_ndiv   <=  5;
              end
              
    3'b010  : begin
                dds_phase_increment <=  4;  dds_prescale_ndiv   <=  5;
              end
              
    3'b011  : begin
                dds_phase_increment <=  6;  dds_prescale_ndiv   <=  5;
              end
              
    3'b100  : begin
                dds_phase_increment <= 12;  dds_prescale_ndiv   <=  5;
              end
              
    3'b101  : begin
                dds_phase_increment <= 12;  dds_prescale_ndiv   <=  5;
              end
              
    3'b110  : begin
                dds_phase_increment <= 12;  dds_prescale_ndiv   <=  5;
              end
              
    3'b111  : begin
                dds_phase_increment <= 12;  dds_prescale_ndiv   <=  5;
              end
              
    default : begin
                dds_phase_increment <= 12;  dds_prescale_ndiv   <=  5;
              end
  endcase 
end 


always @(posedge clk)
begin
  if (reset) dds_prescale_count <= 0;
  else if (dds_prescale_count == (dds_prescale_ndiv-1))
    dds_prescale_count <= 0;
  else dds_prescale_count <= dds_prescale_count + 1;
end
assign dds_clk = (dds_prescale_count == (dds_prescale_ndiv-1));
always @(posedge clk)
begin
  if (reset) dds_phase <= 0;
  else if (dds_clk) dds_phase <= dds_phase + dds_phase_increment;
end

assign pulse = dds_phase[`DDS_BITS-1];  always @(posedge clk)
begin
  delayed_pulse <= pulse;
end
assign clk_out = (pulse && ~delayed_pulse);  endmodule

module rs232rx (
                clk,
                rx_clk,
                reset,
                rxd,
                read,
                data,
                data_ready,
                error_over_run,
                error_under_run,
                error_all_low
                );

parameter START_BITS_PP  = 1;
parameter DATA_BITS_PP  = 8;
parameter STOP_BITS_PP  = 1;
parameter CLOCK_FACTOR_PP  = 16;

parameter m1_idle = 0;
parameter m1_start = 1;
parameter m1_shift = 3;
parameter m1_over_run = 2;
parameter m1_under_run = 4;
parameter m1_all_low = 5;
parameter m1_extra_1 = 6;
parameter m1_extra_2 = 7;
parameter m2_data_ready_flag = 1;
parameter m2_data_ready_ack = 0;


input clk; 
input rx_clk; 
input reset;
input rxd;
input read;

output [DATA_BITS_PP-1:0] data;
output data_ready;
output error_over_run;
output error_under_run;
output error_all_low;

reg [DATA_BITS_PP-1:0] data;
reg data_ready;
reg error_over_run;
reg error_under_run;
reg error_all_low;

`define TOTAL_BITS START_BITS_PP + DATA_BITS_PP + STOP_BITS_PP

wire word_xfer_l;
wire mid_bit_l;
wire start_bit_l;
wire stop_bit_l;
wire all_low_l;

reg [3:0] intrabit_count_l;
reg [`TOTAL_BITS-1:0] q;
reg shifter_preset;
reg [2:0] m1_state;
reg [2:0] m1_next_state;
reg m2_state;
reg m2_next_state;


  always @(posedge clk)
  begin : m1_state_register
    if (reset) m1_state <= m1_idle;
    else m1_state <= m1_next_state;
  end 

  always @(m1_state 
           or reset
           or rxd
           or mid_bit_l
           or all_low_l
           or start_bit_l
           or stop_bit_l
           )
  begin : m1_state_logic
  
    shifter_preset <= 0;
    error_over_run <= 0;
    error_under_run <= 0;
    error_all_low <= 0;
  
    case (m1_state)

      m1_idle :
        begin
          shifter_preset <= 1'b1;
          if (~rxd) m1_next_state <= m1_start;
          else m1_next_state <= m1_idle;
        end

      m1_start :
        begin
          if (~rxd && mid_bit_l) m1_next_state <= m1_shift;
          else if (rxd && mid_bit_l) m1_next_state <= m1_under_run;
          else m1_next_state <= m1_start;
        end

      m1_shift :
        begin
          if (all_low_l) m1_next_state <= m1_all_low;
          else if (~start_bit_l && ~stop_bit_l) m1_next_state <= m1_over_run;
          else if (~start_bit_l && stop_bit_l) m1_next_state <= m1_idle;
          else m1_next_state <= m1_shift;
        end

      m1_over_run :
        begin
          error_over_run <= 1;
          shifter_preset <= 1'b1;
          if (reset) m1_next_state <= m1_idle;
          else m1_next_state <= m1_over_run;
        end
      
      m1_under_run :
        begin
          error_under_run <= 1;
          shifter_preset <= 1'b1;
          if (reset) m1_next_state <= m1_idle;
          else m1_next_state <= m1_under_run;
        end
        
      m1_all_low :
        begin
          error_all_low <= 1;
          shifter_preset <= 1'b1;
          if (reset) m1_next_state <= m1_idle;
          else m1_next_state <= m1_all_low;
        end
        
      default : m1_next_state <= m1_idle;
    endcase 
  end 
  assign word_xfer_l = ((m1_state == m1_shift) && ~start_bit_l && stop_bit_l);

  always @(posedge clk)
  begin : m2_state_register
    if (reset) m2_state <= m2_data_ready_ack;
    else m2_state <= m2_next_state;
  end 

  always @(m2_state or word_xfer_l or read)
  begin : m2_state_logic
    case (m2_state)
      m2_data_ready_ack:
            begin
              data_ready <= 1'b0;
              if (word_xfer_l) m2_next_state <= m2_data_ready_flag;
              else m2_next_state <= m2_data_ready_ack;
            end
      m2_data_ready_flag:
            begin
              data_ready <= 1'b1;
              if (read) m2_next_state <= m2_data_ready_ack;
              else m2_next_state <= m2_data_ready_flag;
            end
      default : m2_next_state <= m2_data_ready_ack;
    endcase 
  end 

  always @(posedge clk)
  begin
    if (shifter_preset) intrabit_count_l <= 0;
    else if (rx_clk)
    begin
      if (intrabit_count_l == (CLOCK_FACTOR_PP-1)) intrabit_count_l <= 0;
      else intrabit_count_l <= intrabit_count_l + 1;
    end
  end
  assign mid_bit_l = ((intrabit_count_l==(CLOCK_FACTOR_PP / 2)) && rx_clk);

  always @(posedge clk)
  begin : rxd_shifter
    if (shifter_preset) q <= -1; else if (mid_bit_l) q <= {rxd,q[`TOTAL_BITS-1:1]};
  end
  assign start_bit_l = q[0];
  assign stop_bit_l = q[`TOTAL_BITS-1];
  assign all_low_l = ~(| q); always @(posedge clk)
  begin : rxd_output
    if (reset) data <= 0;
    else if (word_xfer_l) 
      data <= q[START_BITS_PP+DATA_BITS_PP-1:START_BITS_PP];
  end

endmodule

module rs232tx (
                clk,
                tx_clk,
                reset,
                load,
                data,
                load_request,
                txd
                );

  parameter START_BITS_PP  = 1;
  parameter DATA_BITS_PP  = 8;
  parameter STOP_BITS_PP  = 1;
  parameter CLOCK_FACTOR_PP  = 16;
  parameter TX_BIT_COUNT_BITS_PP = 4;  parameter m1_idle = 0;
  parameter m1_waiting = 1;
  parameter m1_sending = 3;
  parameter m1_sending_last_bit = 2;


input clk;
  input tx_clk;
  input reset;
  input load;
  input[DATA_BITS_PP-1:0] data;
  output load_request;
  output txd;

  reg load_request;

`define TOTAL_BITS START_BITS_PP + DATA_BITS_PP + STOP_BITS_PP
  
  reg [`TOTAL_BITS-1:0] q;                 reg [TX_BIT_COUNT_BITS_PP-1:0] tx_bit_count_l;
  reg [3:0] prescaler_count_l;
  reg [1:0] m1_state;
  reg [1:0] m1_next_state;

  wire [`TOTAL_BITS-1:0] tx_word = {{STOP_BITS_PP{1'b1}},
                                   data,
                                   {START_BITS_PP{1'b0}}};
  wire begin_last_bit;
  wire start_sending;
  wire tx_clk_1x;

  always @(posedge clk)
  begin
    if (reset) prescaler_count_l <= 0;
    else if (tx_clk)
    begin
      if (prescaler_count_l == (CLOCK_FACTOR_PP-1)) prescaler_count_l <= 0;
      else prescaler_count_l <= prescaler_count_l + 1;
    end
  end
  assign tx_clk_1x = ((prescaler_count_l == (CLOCK_FACTOR_PP-1) ) && tx_clk);

  always @(posedge clk)
  begin
    if (start_sending) tx_bit_count_l <= 0;
    else if (tx_clk_1x)
    begin
      if (tx_bit_count_l == (`TOTAL_BITS-2)) tx_bit_count_l <= 0;
      else tx_bit_count_l <= tx_bit_count_l + 1;
    end
  end
  assign begin_last_bit = ((tx_bit_count_l == (`TOTAL_BITS-2) ) && tx_clk_1x);

  assign start_sending = (tx_clk_1x && load);


  always @(posedge clk)
  begin : state_register
    if (reset) m1_state <= m1_idle;
    else m1_state <= m1_next_state;
  end

  always @(m1_state or tx_clk_1x or load or begin_last_bit)
  begin : state_logic
    load_request <= 0;
    case (m1_state)
      m1_idle :
            begin
              load_request <= tx_clk_1x;
              if (tx_clk_1x && load) m1_next_state <= m1_sending;
              else m1_next_state <= m1_idle;
            end
      m1_sending :
            begin
              if (begin_last_bit) m1_next_state <= m1_sending_last_bit;
              else m1_next_state <= m1_sending;
            end
      m1_sending_last_bit :
            begin
              load_request <= tx_clk_1x;
              if (load & tx_clk_1x) m1_next_state <= m1_sending;
              else if (tx_clk_1x) m1_next_state <= m1_idle;
              else m1_next_state <= m1_sending_last_bit;
            end
      default :
            begin
              m1_next_state <= m1_idle;
            end
    endcase
  end


  always @(posedge clk)
  begin : txd_shifter
    if (reset) q <= 0;  else if (start_sending) q <= ~tx_word;
    else if (tx_clk_1x) q <= {1'b0,q[`TOTAL_BITS-1:1]};
  end
  
  assign txd = ~q[0];

endmodule