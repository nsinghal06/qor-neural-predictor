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