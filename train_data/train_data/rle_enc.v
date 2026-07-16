//919
module rle_enc(
  clock, reset, 
  enable, arm, 
  rle_mode, disabledGroups, 
  dataIn, validIn, 
  dataOut, validOut);

input clock, reset;
input enable, arm;
input [1:0] rle_mode;
input [3:0] disabledGroups;
input [31:0] dataIn;
input validIn;
output [31:0] dataOut;
output validOut;

localparam TRUE = 1'b1;
localparam FALSE = 1'b0;
localparam RLE_COUNT = 1'b1;


reg active, next_active;
reg mask_flag, next_mask_flag;
reg [1:0] mode, next_mode;
reg [30:0] data_mask, next_data_mask;
reg [30:0] last_data, next_last_data;
reg last_valid, next_last_valid;
reg [31:0] dataOut, next_dataOut;
reg validOut, next_validOut;

reg [30:0] count, next_count;		reg [8:0] fieldcount, next_fieldcount;	reg [1:0] track, next_track;		wire [30:0] inc_count = count+1'b1;
wire count_zero = ~|count;
wire count_gt_one = track[1];
wire count_full = (count==data_mask);

reg mismatch;

wire [30:0] masked_dataIn = dataIn & data_mask;


wire rle_repeat_mode = 0; always @ (posedge clock)
begin
  mode = next_mode;
  data_mask = next_data_mask;
end
always @*
begin
  next_mode = 2'h3; case (disabledGroups)
    4'b1110,4'b1101,4'b1011,4'b0111 : next_mode = 2'h0; 4'b1100,4'b1010,4'b0110,4'b1001,4'b0101,4'b0011 : next_mode = 2'h1; 4'b1000,4'b0100,4'b0010,4'b0001 : next_mode = 2'h2; endcase

  next_data_mask = 32'h7FFFFFFF;
  case (mode)
    2'h0 : next_data_mask = 32'h0000007F;
    2'h1 : next_data_mask = 32'h00007FFF;
    2'h2 : next_data_mask = 32'h007FFFFF;
  endcase
end


initial begin active=0; mask_flag=0; count=0; fieldcount=0; track=0; validOut=0; last_valid=0; end
always @ (posedge clock or posedge reset)
begin
  if (reset)
    begin
      active = 0;
      mask_flag = 0;
    end
  else 
    begin
      active = next_active;
      mask_flag = next_mask_flag;
    end
end

always @ (posedge clock)
begin
  count = next_count;
  fieldcount = next_fieldcount;
  track = next_track;
  dataOut = next_dataOut;
  validOut = next_validOut;
  last_data = next_last_data;
  last_valid = next_last_valid;
end

always @*
begin
  next_active = active | (enable && arm);
  next_mask_flag = mask_flag | (enable && arm); next_dataOut = (mask_flag) ? masked_dataIn : dataIn;
  next_validOut = validIn;
  next_last_data = (validIn) ? masked_dataIn : last_data; 
  next_last_valid = FALSE;
  next_count = count & {31{active}};
  next_fieldcount = fieldcount & {9{active}};
  next_track = track & {2{active}};

  mismatch = |(masked_dataIn^last_data); if (active)
    begin
      next_validOut = FALSE;
      next_last_valid = last_valid | validIn;

      if (validIn && last_valid)
        if (!enable || mismatch || count_full) begin
	    next_active = enable;
            next_validOut = TRUE;
            next_dataOut = {RLE_COUNT,count};
            case (mode)
              2'h0 : next_dataOut = {RLE_COUNT,count[6:0]};
              2'h1 : next_dataOut = {RLE_COUNT,count[14:0]};
              2'h2 : next_dataOut = {RLE_COUNT,count[22:0]};
            endcase
            if (!count_gt_one) next_dataOut = last_data;

	    next_fieldcount = fieldcount+1'b1; next_count = (mismatch || ~rle_mode[1] || ~rle_mode[0] & fieldcount[8]) ? 0 : 1;
	    next_track = next_count[1:0];
          end
        else begin
            next_count = inc_count;
	    if (count_zero) begin
		next_fieldcount = 0;
		next_validOut = TRUE;
	      end
	    if (rle_repeat_mode && count_zero) next_count = 2;
	    next_track = {|track,1'b1};
	  end
    end
end
endmodule