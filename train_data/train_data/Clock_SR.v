//776
module Clock_SR #(parameter WIDTH=170,parameter CNT_WIDTH=8, parameter DIV_WIDTH=6, parameter COUNT_WIDTH=64 )(
    input clk_in, input rst, input[CNT_WIDTH-1:0] count, input start, input start_tmp, input [DIV_WIDTH-1:0] div, input [COUNT_WIDTH-1:0] counter, output reg clk_sr );
reg [1:0] current_state, next_state;
parameter s0 = 2'b01;
parameter s1 = 2'b10;
always@(posedge clk_in or posedge rst)
  begin   
    if(rst)
    begin  current_state <= s0; end
    else
    begin  current_state <= next_state; end    
  end

always@(current_state or rst or count or start or start_tmp)
  begin
    if(rst)
    begin next_state = s0; end
    else
    begin
        case(current_state)
            s0:next_state=(start==0&&start_tmp==1)?s1:s0;
            s1:next_state=(count==WIDTH+1'b1)?s0:s1;
default:next_state=s0;
        endcase
    end
  end

always@(posedge clk_in or posedge rst)
begin
  if(rst)
  begin 
  clk_sr<=1;
  end
  else
  begin
    case(next_state)
        s0:
          begin 
          clk_sr<=1; 
          end
        s1:
          begin 
          clk_sr<=~counter[div-1];   
          end
        default:
          begin 
          clk_sr<=1; 
          end
    endcase 
  end 
end

endmodule