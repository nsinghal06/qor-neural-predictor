//634
module posted_pkt_scheduler_4radios(
    input clk,
	 input rst,
	 input [2:0]    max_pay_size,
	 input [63:0]   RX_FIFO_data,
	 output     	 RX_FIFO_RDEN,
	 input          RX_FIFO_pempty,
	 input [31:0]   RX_TS_FIFO_data,
	 output			 RX_TS_FIFO_RDEN,
	 input          RX_TS_FIFO_empty,
	 input [63:0]   RX_FIFO_2nd_data,
	 output      	 RX_FIFO_2nd_RDEN,
	 input          RX_FIFO_2nd_pempty,
	 input [31:0]   RX_TS_FIFO_2nd_data,
	 output			 RX_TS_FIFO_2nd_RDEN,
	 input          RX_TS_FIFO_2nd_empty,
	 input [63:0]   RX_FIFO_3rd_data,
	 output      	 RX_FIFO_3rd_RDEN,
	 input          RX_FIFO_3rd_pempty,
	 input [31:0]   RX_TS_FIFO_3rd_data,
	 output			 RX_TS_FIFO_3rd_RDEN,
	 input          RX_TS_FIFO_3rd_empty,
	 input [63:0]   RX_FIFO_4th_data,
	 output      	 RX_FIFO_4th_RDEN,
	 input          RX_FIFO_4th_pempty,
	 input [31:0]   RX_TS_FIFO_4th_data,
	 output			 RX_TS_FIFO_4th_RDEN,
	 input          RX_TS_FIFO_4th_empty,
	 input          TX_desc_write_back_req,
	 output reg     TX_desc_write_back_ack,
	 input [63:0]   SourceAddr,
	 input [31:0]   DestAddr,
	 input [23:0]   FrameSize,
	 input [7:0]    FrameControl,
	 input [63:0]   DescAddr,
	 input          RXEnable,
	 input [63:0]   RXBuf_1stAddr,
	 input [31:0]   RXBuf_1stSize,
	 input          RXEnable_2nd,
	 input [63:0]   RXBuf_2ndAddr,
	 input [31:0]   RXBuf_2ndSize,
	 input          RXEnable_3rd,
	 input [63:0]   RXBuf_3rdAddr,
	 input [31:0]   RXBuf_3rdSize,
	 input          RXEnable_4th,
	 input [63:0]   RXBuf_4thAddr,
	 input [31:0]   RXBuf_4thSize,
	 output reg [63:0]   dma_write_data_fifo_data,
	 output reg          dma_write_data_fifo_wren,
	 input               dma_write_data_fifo_full,
	 output reg        go,
	 input             ack,
	 output reg [63:0] dmawad,
	 output     [9:0]  length,
	 input           posted_fifo_full
	 );

	 localparam IDLE                = 5'b00000;
	 localparam TX_DESC_WRITE_BACK  = 5'b00001;
	 localparam TX_DESC_WRITE_BACK2 = 5'b00010;
	 localparam TX_DESC_WRITE_BACK3 = 5'b00011;
	 localparam TX_DESC_WRITE_BACK4 = 5'b00100;
	 localparam WAIT_FOR_ACK        = 5'b00101;
	 localparam RX_PACKET           = 5'b00110;
	 localparam RX_PACKET2          = 5'b00111;
    localparam RX_PACKET3          = 5'b01000;	 
	 localparam RX_PACKET4          = 5'b01001;
	 localparam RX_PACKET5          = 5'b01010;
	 localparam RX_PACKET6          = 5'b01011;
	 localparam RX_PACKET_WAIT_FOR_ACK = 5'b01100;
	 localparam RX_DESC_WAIT        = 5'b10011;
	 localparam RX_DESC             = 5'b01101;
	 localparam RX_DESC2            = 5'b01110;
	 localparam RX_CLEAR            = 5'b10000;
	 localparam RX_CLEAR2           = 5'b11111;
	 localparam RX_CLEAR_WAIT_FOR_ACK = 5'b10101;
	 localparam RX_CLEAR_WAIT         = 5'b11100;
	 
	 reg [4:0] state;
	 
	 localparam RX_FRAME_SIZE_BYTES = 13'h0070;    localparam TX_DESC_SIZE_BYTES  = 13'h0020;    localparam RX_DESC_SIZE_BYTES  = 13'h0010;    reg [1:0]	pathindex_inturn;		reg			RX_FIFO_RDEN_cntl;	reg			RX_TS_FIFO_RDEN_cntl;	wire [31:0]	RX_TS_FIFO_data_cntl;
	 
	 reg [13:0]  cnt;            reg [63:0]  fifo_data_pipe; reg  [12:0] length_byte; reg         buf_inuse;      reg [31:0]  RoundNumber;	  reg [31:0]  RoundNumber_next;
	  reg [63:0]  dmawad_now1_1st, dmawad_now2_1st;
    reg [63:0]  dmawad_next_1st;     reg [63:0]   RXBuf_1stAddr_r1, RXBuf_1stAddr_r2;
	 reg [31:0]   RXBuf_1stSize_r;

reg         buf_inuse_2nd;      reg [31:0]  RoundNumber_2nd;	  reg [31:0]  RoundNumber_next_2nd;
	  reg [63:0]  dmawad_now1_2nd, dmawad_now2_2nd;
    reg [63:0]  dmawad_next_2nd;     reg [63:0]   RXBuf_2ndAddr_r1, RXBuf_2ndAddr_r2;
	 reg [31:0]   RXBuf_2ndSize_r;

reg         buf_inuse_3rd;      reg [31:0]  RoundNumber_3rd;	  reg [31:0]  RoundNumber_next_3rd;
	  reg [63:0]  dmawad_now1_3rd, dmawad_now2_3rd;
    reg [63:0]  dmawad_next_3rd;     reg [63:0]   RXBuf_3rdAddr_r1, RXBuf_3rdAddr_r2;
	 reg [31:0]   RXBuf_3rdSize_r;

reg         buf_inuse_4th;      reg [31:0]  RoundNumber_4th;	  reg [31:0]  RoundNumber_next_4th;
	  reg [63:0]  dmawad_now1_4th, dmawad_now2_4th;
    reg [63:0]  dmawad_next_4th;     reg [63:0]   RXBuf_4thAddr_r1, RXBuf_4thAddr_r2;
	 reg [31:0]   RXBuf_4thSize_r;

	 
	 reg         rst_reg;	 
	 always@(posedge clk) rst_reg <= rst;

always@(posedge clk)begin
	    RXBuf_1stAddr_r1 <= RXBuf_1stAddr;
		 RXBuf_1stAddr_r2 <= RXBuf_1stAddr;
		 RXBuf_1stSize_r <= RXBuf_1stSize;
	 end

	 always@(posedge clk)begin
	    RXBuf_2ndAddr_r1 <= RXBuf_2ndAddr;
		 RXBuf_2ndAddr_r2 <= RXBuf_2ndAddr;
		 RXBuf_2ndSize_r <= RXBuf_2ndSize;
	 end
	 
	 always@(posedge clk)begin
	    RXBuf_3rdAddr_r1 <= RXBuf_3rdAddr;
		 RXBuf_3rdAddr_r2 <= RXBuf_3rdAddr;
		 RXBuf_3rdSize_r <= RXBuf_3rdSize;
	 end
	 
	 always@(posedge clk)begin
	    RXBuf_4thAddr_r1 <= RXBuf_4thAddr;
		 RXBuf_4thAddr_r2 <= RXBuf_4thAddr;
		 RXBuf_4thSize_r <= RXBuf_4thSize;
	 end

	 wire [12:0] frame_size_bytes;    wire [12:0] max_pay_size_bytes;  assign max_pay_size_bytes =13'h0001<<(max_pay_size+7);
	assign frame_size_bytes = (RX_FRAME_SIZE_BYTES <= max_pay_size_bytes) ? RX_FRAME_SIZE_BYTES : 
																									max_pay_size_bytes; 
	always@(posedge clk) begin
		if (rst_reg)
			 TX_desc_write_back_ack <= 1'b0;
		else if (state == TX_DESC_WRITE_BACK)
			 TX_desc_write_back_ack <= 1'b1;
		else
			 TX_desc_write_back_ack <= 1'b0;	    
	end

	always@(posedge clk) fifo_data_pipe[63:0] <= (pathindex_inturn[1] == 1'b0) ?
																	(	(pathindex_inturn[0] == 1'b0) ?
																			{RX_FIFO_data[15:0],RX_FIFO_data[31:16],
																			 RX_FIFO_data[47:32],RX_FIFO_data[63:48]} : 
																			{RX_FIFO_2nd_data[15:0],RX_FIFO_2nd_data[31:16],
																			 RX_FIFO_2nd_data[47:32],RX_FIFO_2nd_data[63:48]}
																	)
																:	(	(pathindex_inturn[0] == 1'b0) ?	 
																			{RX_FIFO_3rd_data[15:0],RX_FIFO_3rd_data[31:16],
																			 RX_FIFO_3rd_data[47:32],RX_FIFO_3rd_data[63:48]} : 
																			{RX_FIFO_4th_data[15:0],RX_FIFO_4th_data[31:16],
																			 RX_FIFO_4th_data[47:32],RX_FIFO_4th_data[63:48]}
																	);

assign RX_FIFO_RDEN 		= (pathindex_inturn == 2'b00) & RX_FIFO_RDEN_cntl;
	assign RX_FIFO_2nd_RDEN	= (pathindex_inturn == 2'b01) & RX_FIFO_RDEN_cntl;
	assign RX_FIFO_3rd_RDEN	= (pathindex_inturn == 2'b10) & RX_FIFO_RDEN_cntl;
	assign RX_FIFO_4th_RDEN	= (pathindex_inturn == 2'b11) & RX_FIFO_RDEN_cntl;
	
	assign RX_TS_FIFO_RDEN 		= (pathindex_inturn == 2'b00) & RX_TS_FIFO_RDEN_cntl;
	assign RX_TS_FIFO_2nd_RDEN	= (pathindex_inturn == 2'b01) & RX_TS_FIFO_RDEN_cntl;
	assign RX_TS_FIFO_3rd_RDEN	= (pathindex_inturn == 2'b10) & RX_TS_FIFO_RDEN_cntl;
	assign RX_TS_FIFO_4th_RDEN	= (pathindex_inturn == 2'b11) & RX_TS_FIFO_RDEN_cntl;
	
	assign RX_TS_FIFO_data_cntl[31:0] = (pathindex_inturn[1] == 1'b0) ?
												(	(pathindex_inturn[0] == 1'b0) ?	RX_TS_FIFO_data[31:0] : RX_TS_FIFO_2nd_data[31:0]	)
											:	(	(pathindex_inturn[0] == 1'b0) ?	RX_TS_FIFO_3rd_data[31:0] : RX_TS_FIFO_4th_data[31:0]	);
	
	always@ (posedge clk) begin
		if (rst_reg) begin
			 state <= IDLE;
			 RX_FIFO_RDEN_cntl <= 1'b0;
			 RX_TS_FIFO_RDEN_cntl	<= 1'b0;
			 dma_write_data_fifo_wren <= 1'b0;
			 dma_write_data_fifo_data <= 64'h0000_0000_0000_0000;
			 go <= 1'b0;
			 buf_inuse <= 1'b0;
			 buf_inuse_2nd <= 1'b0;
			 buf_inuse_3rd <= 1'b0;
			 buf_inuse_4th <= 1'b0;
			 pathindex_inturn	<= 2'b00;
			 cnt <= 13'h0000;
		end else begin
			 case (state)
				IDLE : begin
						cnt <= 13'h0000;
						go <= 1'b0;
						RX_FIFO_RDEN_cntl <= 1'b0;
						dma_write_data_fifo_wren <= 1'b0;
						dma_write_data_fifo_data <= 64'h0000_0000_0000_0000;
						if(~posted_fifo_full & ~dma_write_data_fifo_full) begin
							if(TX_desc_write_back_req)
							  state <= TX_DESC_WRITE_BACK;
							else begin
								casex({	pathindex_inturn[1:0], 
											((~RX_FIFO_pempty)&(~RX_TS_FIFO_empty)), 
											((~RX_FIFO_2nd_pempty)&(~RX_TS_FIFO_2nd_empty)), 
											((~RX_FIFO_3rd_pempty)&(~RX_TS_FIFO_3rd_empty)), 
											((~RX_FIFO_4th_pempty)&(~RX_TS_FIFO_4th_empty))	})
								
									6'b00_1xxx, 6'b01_1000, 6'b10_1x00, 6'b11_1xx0: begin		pathindex_inturn	<= 2'b00;
										buf_inuse			<= 1'b1;
										cnt 					<= frame_size_bytes;
										RX_TS_FIFO_RDEN_cntl	<= 1'b1;
										state 				<= RX_CLEAR;
									end
									
									6'b00_01xx, 6'b01_x1xx, 6'b10_0100, 6'b11_01x0: begin		pathindex_inturn	<= 2'b01;
										buf_inuse_2nd		<= 1'b1;
										cnt 					<= frame_size_bytes;
										RX_TS_FIFO_RDEN_cntl	<= 1'b1;
										state 				<= RX_CLEAR;
									end
									
									6'b00_001x, 6'b01_x01x, 6'b10_xx1x, 6'b11_0010: begin		pathindex_inturn	<= 2'b10;
										buf_inuse_3rd		<= 1'b1;
										cnt 					<= frame_size_bytes;
										RX_TS_FIFO_RDEN_cntl	<= 1'b1;
										state 				<= RX_CLEAR;
									end
									
									6'b00_0001, 6'b01_x001, 6'b10_xx01, 6'b11_xxx1: begin		pathindex_inturn	<= 2'b11;
										buf_inuse_4th		<= 1'b1;
										cnt 					<= frame_size_bytes;
										RX_TS_FIFO_RDEN_cntl	<= 1'b1;
										state 				<= RX_CLEAR;
									end
									
									default: begin			RX_TS_FIFO_RDEN_cntl	<= 1'b1;
										state <= IDLE;
									end
									
								endcase
								
end
						end else
							 state <= IDLE;
					end
				TX_DESC_WRITE_BACK : begin     go <= 1'b0;
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						dma_write_data_fifo_wren <= 1'b1;
						dma_write_data_fifo_data[63:0] <= 64'h0000_0000_0000_0000;
						state <= TX_DESC_WRITE_BACK2;					
					end
				TX_DESC_WRITE_BACK2 : begin
						go <= 1'b0;
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						dma_write_data_fifo_wren <= 1'b1;
						dma_write_data_fifo_data[63:0] <= SourceAddr;
						state <= TX_DESC_WRITE_BACK3;
					end
				TX_DESC_WRITE_BACK3 : begin
						go <= 1'b0;
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						dma_write_data_fifo_wren <= 1'b1;
						dma_write_data_fifo_data[63:0] <= {32'h0000_0000,DestAddr};
						state <= TX_DESC_WRITE_BACK4;
					end
				TX_DESC_WRITE_BACK4 : begin
						go <= 1'b1;
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						dma_write_data_fifo_wren <= 1'b1;
						dma_write_data_fifo_data[63:0] <= {32'h0000_0000,FrameControl,FrameSize};
						state <= WAIT_FOR_ACK;
					end
				WAIT_FOR_ACK : begin
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						dma_write_data_fifo_wren <= 1'b0;
						dma_write_data_fifo_data[63:0] <= 64'h0000_0000_0000_0000;
						if(ack) begin
						  go <= 1'b0;
						  state <= IDLE;
						end else begin
								go <= 1'b1;
								state <= WAIT_FOR_ACK;
						end
					end
					
				RX_CLEAR : begin
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						go <= 1'b0;
						dma_write_data_fifo_wren <= 1'b1;
						dma_write_data_fifo_data[63:0] <= {64'h0000_0000_0000_0000};
						state <= RX_CLEAR2;
					end
				RX_CLEAR2 : begin
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						go <= 1'b1;
						dma_write_data_fifo_wren <= 1'b1;
						dma_write_data_fifo_data[63:0] <= {RX_TS_FIFO_data_cntl[31:0]+32'h0000_001C,RoundNumber[31:0]};
						state <= RX_CLEAR_WAIT_FOR_ACK;	
					end
				RX_CLEAR_WAIT_FOR_ACK : begin
	dma_write_data_fifo_wren <= 1'b0;
						dma_write_data_fifo_data[63:0] <= 64'h0000_0000_0000_0000;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						if(ack) begin
							go <= 1'b0;
							if (~posted_fifo_full & ~dma_write_data_fifo_full) begin
								RX_FIFO_RDEN_cntl <= 1'b1;
								state <= RX_PACKET;
							end else begin
								RX_FIFO_RDEN_cntl <= 1'b0;
								state <= RX_CLEAR_WAIT;
							end
						end else begin
							go <= 1'b1;
							RX_FIFO_RDEN_cntl <= 1'b0;
							state <= RX_CLEAR_WAIT_FOR_ACK;
						end
					end
				RX_CLEAR_WAIT : begin
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						if (~posted_fifo_full & ~dma_write_data_fifo_full) begin
							RX_FIFO_RDEN_cntl <= 1'b1;
							state <= RX_PACKET;
						end else begin
							RX_FIFO_RDEN_cntl <= 1'b0;
							state <= RX_CLEAR_WAIT;
						end
				end
				
				RX_PACKET : begin
						go <= 1'b0;
						cnt <= cnt - 13'h0008;
						RX_FIFO_RDEN_cntl <= 1'b1;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						dma_write_data_fifo_wren <= 1'b0;
						dma_write_data_fifo_data[63:0] <= 64'h0000_0000_0000_0000;
						state <= RX_PACKET2;
					end
				RX_PACKET2 : begin
						go <= 1'b0;
						cnt <= cnt - 13'h0008;
						RX_FIFO_RDEN_cntl <= 1'b1;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						dma_write_data_fifo_wren <= 1'b0;
						dma_write_data_fifo_data[63:0] <= 64'h0000_0000_0000_0000;
	state <= RX_PACKET3;
					end
				RX_PACKET3 : begin
						go <= 1'b0;
						RX_FIFO_RDEN_cntl <= 1'b1;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						dma_write_data_fifo_wren <= 1'b1;
	dma_write_data_fifo_data[63:0] <= fifo_data_pipe[63:0];
						if (cnt == 13'h0010) begin
							state <= RX_PACKET4;
						end else begin
								cnt   <= cnt - 13'h0008;
								state <= RX_PACKET3;
						end
					end
				RX_PACKET4 : begin
						go <= 1'b0;
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						dma_write_data_fifo_wren <= 1'b1;
	dma_write_data_fifo_data[63:0] <= fifo_data_pipe[63:0];
						state <= RX_PACKET5;
					end
				RX_PACKET5 : begin
						go <= 1'b0;
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						dma_write_data_fifo_wren <= 1'b1;
	dma_write_data_fifo_data[63:0] <= fifo_data_pipe[63:0];
						state <= RX_PACKET6;
					end
				RX_PACKET6 : begin
						go <= 1'b1;
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						dma_write_data_fifo_wren <= 1'b1;
	dma_write_data_fifo_data[63:0] <= fifo_data_pipe[63:0];
						state <= RX_PACKET_WAIT_FOR_ACK;
					end
				RX_PACKET_WAIT_FOR_ACK : begin
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						dma_write_data_fifo_wren <= 1'b0;
						dma_write_data_fifo_data[63:0] <= 64'h0000_0000_0000_0000;
						if(ack) begin
							go <= 1'b0;
							if (~posted_fifo_full & ~dma_write_data_fifo_full)
								state <= RX_DESC;
							else
								state <= RX_DESC_WAIT;
						end else begin
							go <= 1'b1;
							state <= RX_PACKET_WAIT_FOR_ACK;
						end
					end
				RX_DESC_WAIT : begin
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						if (~posted_fifo_full & ~dma_write_data_fifo_full)
							state <= RX_DESC;
						else
							state <= RX_DESC_WAIT;
				end
					
				RX_DESC : begin
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						go <= 1'b0;
						dma_write_data_fifo_wren <= 1'b1;
						dma_write_data_fifo_data[63:0] <= 64'hFFFF_FFFF_FFFF_FFFF;
						state <= RX_DESC2;
					end
				RX_DESC2 : begin
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						go <= 1'b1;
						dma_write_data_fifo_wren <= 1'b1;
	dma_write_data_fifo_data[63:0] <= {RX_TS_FIFO_data_cntl[31:0],RoundNumber[31:0]};
						state <= WAIT_FOR_ACK;					
					end
				default: begin
						go <= 1'b0;
						RX_FIFO_RDEN_cntl <= 1'b0;
						RX_TS_FIFO_RDEN_cntl	<= 1'b0;
						dma_write_data_fifo_wren <= 1'b0;
						dma_write_data_fifo_data[63:0] <= 64'h0000_0000_0000_0000;
						state <= IDLE;
					end
			endcase
		end
	end

	always@(posedge clk) begin
		if(~buf_inuse | rst_reg) begin
			dmawad_next_1st <= RXBuf_1stAddr_r1;
			RoundNumber_next <= 32'h0000_0000;
		end else if ((state == RX_PACKET3) && (pathindex_inturn[1:0] == 2'b00)) begin
			if((dmawad_now2_1st + 64'h0000_0000_0000_0080) >= (RXBuf_1stAddr_r2+RXBuf_1stSize_r)) begin
				dmawad_next_1st <= RXBuf_1stAddr_r1;
				RoundNumber_next <= RoundNumber + 32'h0000_0001;
			end else begin
				dmawad_next_1st <= dmawad_now1_1st + 64'h0000_0000_0000_0080;
				RoundNumber_next <= RoundNumber_next;
			end
		end else begin
				dmawad_next_1st <= dmawad_next_1st;
				RoundNumber_next <= RoundNumber_next;
			 end
	end

	always@(posedge clk) begin
		if(~buf_inuse_2nd | rst_reg) begin
			dmawad_next_2nd <= RXBuf_2ndAddr_r1;
			RoundNumber_next_2nd <= 32'h0000_0000;
		end else if ((state == RX_PACKET3) && (pathindex_inturn[1:0] == 2'b01)) begin
			if((dmawad_now2_2nd + 64'h0000_0000_0000_0080) >= (RXBuf_2ndAddr_r2+RXBuf_2ndSize_r)) begin
				dmawad_next_2nd <= RXBuf_2ndAddr_r1;
				RoundNumber_next_2nd <= RoundNumber_2nd + 32'h0000_0001;
			end else begin
				dmawad_next_2nd <= dmawad_now1_2nd + 64'h0000_0000_0000_0080;
				RoundNumber_next_2nd <= RoundNumber_next_2nd;
			end
		end else begin
				dmawad_next_2nd <= dmawad_next_2nd;
				RoundNumber_next_2nd <= RoundNumber_next_2nd;
			 end
	end

	always@(posedge clk) begin
		if(~buf_inuse_3rd | rst_reg) begin
			dmawad_next_3rd <= RXBuf_3rdAddr_r1;
			RoundNumber_next_3rd <= 32'h0000_0000;
		end else if ((state == RX_PACKET3) && (pathindex_inturn[1:0] == 2'b10)) begin
			if((dmawad_now2_3rd + 64'h0000_0000_0000_0080) >= (RXBuf_3rdAddr_r2+RXBuf_3rdSize_r)) begin
				dmawad_next_3rd <= RXBuf_3rdAddr_r1;
				RoundNumber_next_3rd <= RoundNumber_3rd + 32'h0000_0001;
			end else begin
				dmawad_next_3rd <= dmawad_now1_3rd + 64'h0000_0000_0000_0080;
				RoundNumber_next_3rd <= RoundNumber_next_3rd;
			end
		end else begin
				dmawad_next_3rd <= dmawad_next_3rd;
				RoundNumber_next_3rd <= RoundNumber_next_3rd;
			 end
	end

	always@(posedge clk) begin
		if(~buf_inuse_4th | rst_reg) begin
			dmawad_next_4th <= RXBuf_4thAddr_r1;
			RoundNumber_next_4th <= 32'h0000_0000;
		end else if ((state == RX_PACKET3) && (pathindex_inturn[1:0] == 2'b11)) begin
			if((dmawad_now2_4th + 64'h0000_0000_0000_0080) >= (RXBuf_4thAddr_r2+RXBuf_4thSize_r)) begin
				dmawad_next_4th <= RXBuf_4thAddr_r1;
				RoundNumber_next_4th <= RoundNumber_4th + 32'h0000_0001;
			end else begin
				dmawad_next_4th <= dmawad_now1_4th + 64'h0000_0000_0000_0080;
				RoundNumber_next_4th <= RoundNumber_next_4th;
			end
		end else begin
				dmawad_next_4th <= dmawad_next_4th;
				RoundNumber_next_4th <= RoundNumber_next_4th;
			 end
	end

	always@(posedge clk)begin
		if(state == IDLE)begin
			dmawad_now1_1st <= dmawad_next_1st;
			dmawad_now2_1st <= dmawad_next_1st;
			RoundNumber <= RoundNumber_next;
		end else begin
			dmawad_now1_1st <= dmawad_now1_1st;
			dmawad_now2_1st <= dmawad_now2_1st;
			RoundNumber <= RoundNumber;
		end		
	end

	always@(posedge clk)begin
		if(state == IDLE)begin
			dmawad_now1_2nd <= dmawad_next_2nd;
			dmawad_now2_2nd <= dmawad_next_2nd;
			RoundNumber_2nd <= RoundNumber_next_2nd;
		end else begin
			dmawad_now1_2nd <= dmawad_now1_2nd;
			dmawad_now2_2nd <= dmawad_now2_2nd;
			RoundNumber_2nd <= RoundNumber_2nd;
		end		
	end

	always@(posedge clk)begin
		if(state == IDLE)begin
			dmawad_now1_3rd <= dmawad_next_3rd;
			dmawad_now2_3rd <= dmawad_next_3rd;
			RoundNumber_3rd <= RoundNumber_next_3rd;
		end else begin
			dmawad_now1_3rd <= dmawad_now1_3rd;
			dmawad_now2_3rd <= dmawad_now2_3rd;
			RoundNumber_3rd <= RoundNumber_3rd;
		end		
	end

	always@(posedge clk)begin
		if(state == IDLE)begin
			dmawad_now1_4th <= dmawad_next_4th;
			dmawad_now2_4th <= dmawad_next_4th;
			RoundNumber_4th <= RoundNumber_next_4th;
		end else begin
			dmawad_now1_4th <= dmawad_now1_4th;
			dmawad_now2_4th <= dmawad_now2_4th;
			RoundNumber_4th <= RoundNumber_4th;
		end		
	end

	always@(posedge clk) begin
		if(rst_reg) begin
			dmawad      <= 64'h0000_0000_0000_0000;
		end else if (state == TX_DESC_WRITE_BACK) begin
				dmawad      <= DescAddr;
		end else if (state == RX_CLEAR) begin
				if (pathindex_inturn[1] == 1'b0) begin
					if (pathindex_inturn[0] == 1'b0) begin	if((dmawad_now2_1st + 64'h0000_0000_0000_0080) >= (RXBuf_1stAddr_r2+RXBuf_1stSize_r)) begin
							dmawad <= RXBuf_1stAddr_r1;
						end else begin
							dmawad <= dmawad_now1_1st + 64'h0000_0000_0000_0080;
						end
					end else begin									if((dmawad_now2_2nd + 64'h0000_0000_0000_0080) >= (RXBuf_2ndAddr_r2+RXBuf_2ndSize_r)) begin
							dmawad <= RXBuf_2ndAddr_r1;
						end else begin
							dmawad <= dmawad_now1_2nd + 64'h0000_0000_0000_0080;
						end
					end
				end else begin										
					if (pathindex_inturn[0] == 1'b0) begin	if((dmawad_now2_3rd + 64'h0000_0000_0000_0080) >= (RXBuf_3rdAddr_r2+RXBuf_3rdSize_r)) begin
							dmawad <= RXBuf_3rdAddr_r1;
						end else begin
							dmawad <= dmawad_now1_3rd + 64'h0000_0000_0000_0080;
						end
					end else begin									if((dmawad_now2_4th + 64'h0000_0000_0000_0080) >= (RXBuf_4thAddr_r2+RXBuf_4thSize_r)) begin
							dmawad <= RXBuf_4thAddr_r1;
						end else begin
							dmawad <= dmawad_now1_4th + 64'h0000_0000_0000_0080;
						end
					end
				end
		end else if (state == RX_PACKET) begin    dmawad      <= (pathindex_inturn[1] == 1'b0) ? 
										(	(pathindex_inturn[0] == 1'b0) ?
											dmawad_now1_1st + 64'h0000_0000_0000_0010 : dmawad_now1_2nd + 64'h0000_0000_0000_0010
										)
									:	(	(pathindex_inturn[0] == 1'b0) ?
											dmawad_now1_3rd + 64'h0000_0000_0000_0010 : dmawad_now1_4th + 64'h0000_0000_0000_0010
										);
		end else if (state == RX_DESC) begin
				dmawad      <= (pathindex_inturn[1] == 1'b0) ? 
										(	(pathindex_inturn[0] == 1'b0) ?
											dmawad_now1_1st : dmawad_now1_2nd
										)
									:	(	(pathindex_inturn[0] == 1'b0) ?
											dmawad_now1_3rd : dmawad_now1_4th
										);
		end else begin
				dmawad      <= dmawad;
		end
	end

	always@(posedge clk) begin
		if(rst_reg)
			length_byte[12:0] <= 13'h0000;
		else if (state == TX_DESC_WRITE_BACK)
			length_byte[12:0] <= TX_DESC_SIZE_BYTES[12:0];
		else if (state == RX_CLEAR)
			length_byte[12:0] <= RX_DESC_SIZE_BYTES[12:0];
		else if (state == RX_PACKET)
			length_byte[12:0] <= frame_size_bytes[12:0];
		else if (state == RX_DESC)
			length_byte[12:0] <= RX_DESC_SIZE_BYTES[12:0];
		else
			length_byte <= length_byte;
	end

	assign length[9:0] = length_byte[11:2];

endmodule