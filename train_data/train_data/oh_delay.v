//185
module oh_delay  #(parameter DW = 1, parameter N  = 1  )   
   (
    input [DW-1:0]  in, input 	    clk,output [DW-1:0] out );

   reg [DW-1:0]     sync_pipe[N-1:0];
      
   genvar 	    i;
   generate
      always @ (posedge clk)
	sync_pipe[0]<=in[DW-1:0];
      for(i=1;i<N;i=i+1) begin: gen_pipe
         always @ (posedge clk)
	   sync_pipe[i]<=sync_pipe[i-1];
      end
   endgenerate

   assign out[DW-1:0] = sync_pipe[N-1];
   
endmodule