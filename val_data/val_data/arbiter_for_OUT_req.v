//810
module    arbiter_for_OUT_req(clk,
                               rst,
                               OUT_req_rdy,
                               v_ic_req,
                               v_dc_req,
                               v_mem_req,
                               ic_req_ctrl,
                               dc_req_ctrl,
                               mem_req_ctrl,
                               ack_OUT_req,
                               ack_ic_req,
                               ack_dc_req,
                               ack_mem_req,
                               select
                               );
input                               clk;
input                               rst;
input                               OUT_req_rdy;
input                               v_ic_req;
input                               v_dc_req;
input                               v_mem_req;
input     [1:0]                     ic_req_ctrl;
input     [1:0]                     dc_req_ctrl;
input     [1:0]                     mem_req_ctrl;
                               output                               ack_OUT_req;
output                               ack_ic_req;
output                               ack_dc_req;
output                               ack_mem_req;
output   [2:0]                       select; parameter         arbiter_idle=4'b0001;
parameter         ic_uploading=4'b0010;
parameter         dc_uploading=4'b0100;
parameter         mem_uploading=4'b1000;

reg [3:0] nstate;
reg [3:0] state;
reg [1:0] priority_2;
reg       ack_ic_req;
reg       ack_dc_req;
reg       ack_mem_req;
reg [2:0] select;
reg       ack_OUT_req;
reg       update_priority;

wire [2:0] arbiter_vector;
assign  arbiter_vector={v_ic_req,v_dc_req,v_mem_req};

always@(*)
begin
  ack_ic_req=1'b0;
  ack_dc_req=1'b0;
  ack_mem_req=1'b0;
  select=3'b000;
  ack_OUT_req=1'b0;
  nstate=state;
  update_priority=1'b0;
  case(state)
    arbiter_idle:
      begin
        if(OUT_req_rdy)
        begin
        if(arbiter_vector[2]==1'b1)
          begin
            ack_ic_req=1'b1;
            select=3'b100;
            nstate=ic_uploading;
            ack_OUT_req=1'b1;
          end
        else
          begin
            if(arbiter_vector[1:0]==2'b11)
            begin
                update_priority=1'b1;
              begin
                if(priority_2[1]==1'b1)
                  begin
                    ack_dc_req=1'b1;
                    select=3'b010;
                    nstate=dc_uploading;
                    ack_OUT_req=1'b1;
                  end
                else
                  begin
                    ack_mem_req=1'b1;
                    select=3'b001;
                    nstate=mem_uploading;
                    ack_OUT_req=1'b1;
                  end        
              end
            end
            else if(arbiter_vector[1:0]==2'b10)
              begin
                ack_dc_req=1'b1;
                select=3'b010;
                nstate=dc_uploading;
                ack_OUT_req=1'b1;
              end
            else if(arbiter_vector[1:0]==2'b01)
              begin
                ack_mem_req=1'b1;
                select=3'b001;
                nstate=mem_uploading;
                ack_OUT_req=1'b1;
              end  
          end 
        end
      end
    ic_uploading:
      begin 
        if(OUT_req_rdy)
          begin
            if(ic_req_ctrl==2'b11)
              nstate=arbiter_idle;
            ack_ic_req=1'b1;
            select=3'b100;
            ack_OUT_req=1'b1;
          end
      end
    dc_uploading:
      begin 
        if(OUT_req_rdy)
          begin
            if(dc_req_ctrl==2'b11)
              nstate=arbiter_idle;
            ack_dc_req=1'b1;
            select=3'b010;
            ack_OUT_req=1'b1; 
          end
      end
    mem_uploading:
      begin 
        if(OUT_req_rdy)
          begin
            if(mem_req_ctrl==2'b11)
              nstate=arbiter_idle;
            ack_mem_req=1'b1;
            select=3'b001;
            ack_OUT_req=1'b1;
          end
      end
    endcase
end

always@(posedge clk)
begin
  if(rst)
    state<=4'b0001;
  else
    state<=nstate;
end
always@(posedge clk)
begin
  if(rst)
    priority_2<=2'b01;
  else if(update_priority)
    priority_2<={priority_2[0],priority_2[1]};
end
endmodule