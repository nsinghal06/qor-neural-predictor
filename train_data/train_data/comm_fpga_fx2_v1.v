//610
module
   comm_fpga_fx2_v1(
		 input wire 	   clk_in, input wire 	   reset_in, output reg 	   fx2FifoSel_out, input wire [7:0]  fx2Data_in,
		 output wire [7:0]  fx2Data_out,
		 output wire fx2Data_sel,
		 
		 output wire 	   fx2Read_out, input wire 	   fx2GotData_in, output wire 	   fx2Write_out, input wire 	   fx2GotRoom_in, output reg 	   fx2PktEnd_out, output wire [6:0] chanAddr_out, output wire [7:0] h2fData_out, output reg 	   h2fValid_out, input wire 	   h2fReady_in, input wire [7:0]  f2hData_in, input wire 	   f2hValid_in, output reg 	   f2hReady_out     );
   
   localparam[3:0] S_IDLE                    = 4'h0;     localparam[3:0] S_GET_COUNT0              = 4'h1;     localparam[3:0] S_GET_COUNT1              = 4'h2;     localparam[3:0] S_GET_COUNT2              = 4'h3;     localparam[3:0] S_GET_COUNT3              = 4'h4;     localparam[3:0] S_BEGIN_WRITE             = 4'h5;     localparam[3:0] S_WRITE                   = 4'h6;     localparam[3:0] S_END_WRITE_ALIGNED       = 4'h7;     localparam[3:0] S_END_WRITE_NONALIGNED    = 4'h8;     localparam[3:0] S_READ                    = 4'h9;     localparam[1:0] FIFO_READ                 = 2'b10;    localparam[1:0] FIFO_WRITE                = 2'b01;    localparam[1:0] FIFO_NOP                  = 2'b11;    localparam      OUT_FIFO                  = 2'b0;     localparam      IN_FIFO                   = 2'b1;     reg [3:0] 			   state_next, state         = S_IDLE;
   reg [1:0] 			   fifoOp                    = FIFO_NOP;
   reg [31:0] 			   count_next, count         = 32'h0;    reg [6:0] 			   chanAddr_next, chanAddr   = 7'h00;    reg 				   isWrite_next, isWrite     = 1'b0;     reg 				   isAligned_next, isAligned = 1'b0;     reg [7:0] 			   dataOut;                              reg 				   driveBus;                             always @(posedge clk_in)
     begin
	if ( reset_in == 1'b1 )
	  begin
	     state <= S_IDLE;
	     count <= 32'h0;
	     chanAddr <= 7'h00;
	     isWrite <= 1'b0;
	     isAligned <= 1'b0;
	  end
	else
	  begin
	     state <= state_next;
	     count <= count_next;
	     chanAddr <= chanAddr_next;
	     isWrite <= isWrite_next;
	     isAligned <= isAligned_next;
	  end
     end
   
   always @*
     begin
	state_next = state;
	count_next = count;
	chanAddr_next = chanAddr;
	isWrite_next = isWrite;       isAligned_next = isAligned;   dataOut = 8'h00;
	driveBus = 1'b0;              fifoOp = FIFO_READ;           fx2PktEnd_out = 1'b1;         f2hReady_out = 1'b0;
	h2fValid_out = 1'b0;
	
	case ( state )
	  S_GET_COUNT0:
	    begin
	       fx2FifoSel_out = OUT_FIFO;  if ( fx2GotData_in == 1'b1 )
		 begin
		    count_next[31:24] = fx2Data_in;
		    state_next = S_GET_COUNT1;
		 end
	    end
	  
	  S_GET_COUNT1:
	    begin
	       fx2FifoSel_out = OUT_FIFO;  if ( fx2GotData_in == 1'b1 )
		 begin
		    count_next[23:16] = fx2Data_in;
		    state_next = S_GET_COUNT2;
		 end
	    end
	  
	  S_GET_COUNT2:
	    begin
	       fx2FifoSel_out = OUT_FIFO;  if ( fx2GotData_in == 1'b1 )
		 begin
		    count_next[15:8] = fx2Data_in;
		    state_next = S_GET_COUNT3;
		 end
	    end
	  
	  S_GET_COUNT3:
	    begin
	       fx2FifoSel_out = OUT_FIFO;  if ( fx2GotData_in == 1'b1 )
		 begin
		    count_next[7:0] = fx2Data_in;
		    if ( isWrite == 1'b1 )
		      state_next = S_BEGIN_WRITE;
		    else
		      state_next = S_READ;
		 end
	    end
	  
	  S_BEGIN_WRITE:
	    begin
	       fx2FifoSel_out = IN_FIFO;   fifoOp = FIFO_NOP;
	       if ( count[8:0] == 9'b000000000 )
		 isAligned_next = 1'b1;
	       else
		 isAligned_next = 1'b0;
	       state_next = S_WRITE;
	    end
	  
	  S_WRITE:
	    begin
	       fx2FifoSel_out = IN_FIFO;   if ( fx2GotRoom_in == 1'b1 )
		 f2hReady_out = 1'b1;
	       if ( fx2GotRoom_in == 1'b1 && f2hValid_in == 1'b1 )
		 begin
		    fifoOp = FIFO_WRITE;
		    dataOut = f2hData_in;
		    driveBus = 1'b1;
		    count_next = count - 1;
		    if ( count == 32'h1 )
		      begin
			 if ( isAligned == 1'b1 )
			   state_next = S_END_WRITE_ALIGNED;  else
			   state_next = S_END_WRITE_NONALIGNED;  end
		 end
	       else
		 fifoOp = FIFO_NOP;
	    end
	  
	  S_END_WRITE_ALIGNED:
	    begin
	       fx2FifoSel_out = IN_FIFO;   fifoOp = FIFO_NOP;
	       state_next = S_IDLE;
	    end
	  
	  S_END_WRITE_NONALIGNED:
	    begin
	       fx2FifoSel_out = IN_FIFO;   fifoOp = FIFO_NOP;
	       fx2PktEnd_out = 1'b0;       state_next = S_IDLE;
	    end
	  
	  S_READ:
	    begin
	       fx2FifoSel_out = OUT_FIFO;  if ( fx2GotData_in == 1'b1 && h2fReady_in == 1'b1 )
		 begin
		    h2fValid_out = 1'b1;
		    count_next = count - 1;
		    if ( count == 32'h1 )
		      state_next = S_IDLE;
		 end
	       else
		 fifoOp = FIFO_NOP;
	    end
	  
	  default:
	    begin
	       fx2FifoSel_out = OUT_FIFO;  if ( fx2GotData_in == 1'b1 )
		 begin
		    chanAddr_next = fx2Data_in[6:0];
		    isWrite_next = fx2Data_in[7];
		    state_next = S_GET_COUNT0;
		 end
	    end
	endcase
     end
   
   assign fx2Read_out = fifoOp[0];
   assign fx2Write_out = fifoOp[1];
   assign chanAddr_out = chanAddr;
   assign h2fData_out = fx2Data_in;
   assign fx2Data_out = dataOut;
   assign fx2Data_sel = driveBus;
   
			
endmodule