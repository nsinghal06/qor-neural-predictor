//343
module      arbiter_for_mem(clk,
                            rst,
                            v_mem_download,
                            v_d_m_areg,
                            v_i_m_areg,
                            mem_access_done,
                            ack_m_download,
                            ack_d_m_areg,
                            ack_i_m_areg,
                            v_m_download_m,
                            v_d_m_areg_m,
                            v_i_m_areg_m
                            );
                           input                           clk;
 input                           rst;
 input                           v_mem_download;
 input                           v_d_m_areg;
 input                           v_i_m_areg;
 input                           mem_access_done;
                            output                           ack_m_download;
 output                           ack_d_m_areg;
 output                           ack_i_m_areg;
 output                           v_m_download_m;
 output                           v_d_m_areg_m;
 output                           v_i_m_areg_m;  
 parameter       arbiter_idle=2'b00;
 parameter       i_m_areg_busy=2'b01;
 parameter       d_m_areg_busy=2'b10;
 parameter       m_download_busy=2'b11;
 
 reg  [1:0]   nstate;
 reg  [1:0]   state;
 
wire   [2:0] seled_v;
 reg        ack_m_download;
 reg        ack_d_m_areg;
 reg        ack_i_m_areg;
 reg        v_m_download_m;
 reg        v_d_m_areg_m;
 reg        v_i_m_areg_m;
 
 assign seled_v=(v_i_m_areg==1'b1)?3'b100:(v_d_m_areg==1'b1)?3'b010:(v_mem_download==1'b1)?3'b001:3'b000;
 
 always@(*)
 begin
   {ack_i_m_areg,ack_d_m_areg,ack_m_download}=3'b000;
	{v_i_m_areg_m,v_d_m_areg_m,v_m_download_m}=3'b000;
	nstate=state;
   case(state)
     arbiter_idle:
       begin
           {ack_i_m_areg,ack_d_m_areg,ack_m_download}=seled_v;
           {v_i_m_areg_m,v_d_m_areg_m,v_m_download_m}=seled_v;
           if(seled_v==3'b100)
             nstate=i_m_areg_busy;
           else 
           if(seled_v==3'b010)
             nstate=d_m_areg_busy;
           else 
           if(seled_v==3'b001)
             nstate=m_download_busy;
       end   
     i_m_areg_busy:
       begin
         if(mem_access_done)
           begin
             nstate=arbiter_idle;
           end
         {ack_i_m_areg,ack_d_m_areg,ack_m_download}=3'b100;
         {v_i_m_areg_m,v_d_m_areg_m,v_m_download_m}=3'b100;
       end 
     d_m_areg_busy:
       begin
         if(mem_access_done)
           begin
             nstate=arbiter_idle;
           end
         {ack_i_m_areg,ack_d_m_areg,ack_m_download}=3'b010;
         {v_i_m_areg_m,v_d_m_areg_m,v_m_download_m}=3'b010;
       end
     m_download_busy:
       begin
         if(mem_access_done)
           begin
             nstate=arbiter_idle;
           end
         {ack_i_m_areg,ack_d_m_areg,ack_m_download}=3'b001;
         {v_i_m_areg_m,v_d_m_areg_m,v_m_download_m}=3'b001;
       end        
 endcase
end       
always@(posedge clk)
begin
  if(rst)
    state<=2'b00;
  else 
    state<=nstate;
end                         
endmodule