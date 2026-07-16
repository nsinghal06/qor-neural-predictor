//1350
module bw_r_scm (
   stb_rdata_ramc, stb_ld_full_raw, stb_ld_partial_raw, 
   stb_cam_hit_ptr, stb_cam_hit, stb_cam_mhit, 
   stb_cam_data, stb_alt_wr_data, stb_camwr_data, stb_alt_wsel, 
   stb_cam_vld, stb_cam_cm_tid, stb_cam_sqsh_msk, stb_cam_rw_ptr, 
   stb_cam_wptr_vld, stb_cam_rptr_vld, stb_cam_rw_tid, 
   stb_quad_ld_cam, rclk, rst_tri_en
   ) ;	

parameter NUMENTRIES = 32 ;				input	[44:15]		stb_cam_data ;	  input	[44:15]		stb_alt_wr_data ;	  input	[14:0]		stb_camwr_data ;  input			stb_alt_wsel ;
input			stb_cam_vld ;	  input	[1:0]		stb_cam_cm_tid ;  input	[7:0]		stb_cam_sqsh_msk; input 	[2:0]		stb_cam_rw_ptr ;  input 	     		stb_cam_wptr_vld ;input 	     		stb_cam_rptr_vld ;input	[1:0]		stb_cam_rw_tid ;  input 			stb_quad_ld_cam ; input			rclk ;		  input			rst_tri_en ;

output	[44:0]		stb_rdata_ramc ;  output	[7:0]		stb_ld_full_raw ; output	[7:0]		stb_ld_partial_raw ; output	[2:0]		stb_cam_hit_ptr ;
output			stb_cam_hit ;	  output			stb_cam_mhit ;	  
reg [44:0]		stb_rdata_ramc ;
reg [31:0]		rw_wdline ;
reg [44:0]		stb_ramc [NUMENTRIES-1:0] ;
reg [44:0]		ramc_entry ;
reg [36:0]		cam_tag ;
reg [31:0]		ptag_hit ;
reg [7:0]		cam_bmask ;
reg [31:0]		byte_match ;
reg [31:0]		byte_overlap ;
reg [31:0]		ld_full_raw ;
reg [31:0]		ld_partial_raw ;
reg [44:15]		alt_wr_data ;
reg [44:15]		pipe_wr_data ;
reg [14:0]		camwr_data ;
reg			wptr_vld ; 
reg			rptr_vld_tmp ; 
reg [1:0]	  	cam_tid ;
reg [1:0]	  	cam_vld ;
reg			alt_wsel ;

wire		rptr_vld ; 
wire 		ldq ;
wire	[7:0]	sqsh_msk ;
wire 	[7:0]	ld_full_raw_mx ;
wire    [7:0]	ld_partial_raw_mx ;
wire	[7:0]	ptag_hit_mx ;
wire	[7:0]	byte_overlap_mx ;
wire	[7:0]	byte_match_mx ;
wire	[7:0]	cam_hit ;
wire	[44:0]	wdata_ramc ;
wire	[44:0]	cam_data ;
wire	[44:15] wr_data ;
`ifdef FPGA_SYN_SCM
reg	[4:0]	stb_addr;
`endif

   
integer	i,j,k,l ;


wire	scan_ena ;
assign	scan_ena = 1'b0 ;

assign	sqsh_msk[7:0]	= stb_cam_sqsh_msk[7:0]; 



`ifdef FPGA_SYN_SCM
`else
always @ (posedge rclk)
        begin
                for (i=0;i<32;i=i+1)
                        begin
                        if ({stb_cam_rw_tid[1:0],stb_cam_rw_ptr[2:0]} == i)
                                rw_wdline[i]  <= 1'b1;
                        else
                                rw_wdline[i]  <= 1'b0;
                        end
        end
`endif

always @(posedge rclk)
	begin
		pipe_wr_data[44:15] <= stb_cam_data[44:15];
		alt_wr_data[44:15] <= stb_alt_wr_data[44:15];
		camwr_data[14:0] <= stb_camwr_data[14:0];
		wptr_vld 	<= stb_cam_wptr_vld ;
		rptr_vld_tmp 	<= stb_cam_rptr_vld ;
		cam_tid[1:0]	<= stb_cam_cm_tid[1:0] ;
		alt_wsel 	<= stb_alt_wsel ;
`ifdef FPGA_SYN_SCM
                stb_addr	<= {stb_cam_rw_tid[1:0],stb_cam_rw_ptr[2:0]};
`endif
	end

assign 	ldq =  stb_quad_ld_cam ;
assign  rptr_vld = rptr_vld_tmp | rst_tri_en ;

assign	wr_data[44:15] = alt_wsel ? 
                alt_wr_data[44:15] : pipe_wr_data[44:15] ;	

assign	wdata_ramc[44:0] = {wr_data[44:15],camwr_data[14:0]};

always @ (negedge rclk)
	begin
`ifdef FPGA_SYN_SCM
	if(wptr_vld) begin
		if(~rst_tri_en) begin
			stb_ramc[stb_addr] <= wdata_ramc[44:0];
			stb_rdata_ramc[44:0] <=  wdata_ramc[44:0];
                end else begin
			stb_rdata_ramc[44:0] <=  stb_ramc[stb_addr];
		end
	end
`else
		for (j=0;j<NUMENTRIES;j=j+1)
			begin
			if (rw_wdline[j] & wptr_vld)
				begin
				if (~rst_tri_en)
					begin
					stb_ramc[j] <=  wdata_ramc[44:0];
					stb_rdata_ramc[44:0] <=  wdata_ramc[44:0];
					end
				else
					begin
					stb_rdata_ramc[44:0] <=  stb_ramc[j];
					end
				end
			end
`endif
`ifdef FPGA_SYN_SCM
		if(rptr_vld & ~scan_ena) begin
			if (rptr_vld & wptr_vld & ~rst_tri_en) begin
				stb_rdata_ramc[44:0] <=  wdata_ramc[44:0];
			end
			else begin
				stb_rdata_ramc[44:0] <=  stb_ramc[stb_addr];
			end
		end
`else
		for (k=0;k<NUMENTRIES;k=k+1)
			begin
			if (rw_wdline[k] & rptr_vld & ~scan_ena)
				begin
				if (rptr_vld & wptr_vld & ~rst_tri_en) stb_rdata_ramc[44:0] <=  wdata_ramc[44:0];
                                else
                                        stb_rdata_ramc[44:0] <=  stb_ramc[k];
				end
			end
`endif
	end

assign	cam_data[44:0] = {stb_cam_data[44:15],stb_camwr_data[14:0]};

always @ (posedge rclk)
	begin
		
		for (l=0;l<NUMENTRIES;l=l+1)
				begin
				ramc_entry[44:0] = stb_ramc[l] ;
				
				cam_tag[36:0] = ramc_entry[44:8] ;
				cam_bmask[7:0] = ramc_entry[7:0] ;
				
				ptag_hit[l] = 
					(cam_tag[36:1] == cam_data[44:9]) & 
						(((cam_tag[0] == cam_data[8]) & ~ldq) | ldq) & stb_cam_vld & ~scan_ena ;
				byte_match[l] = |(cam_bmask[7:0] & cam_data[7:0]) & stb_cam_vld & ~scan_ena ;
				byte_overlap[l] = |(~cam_bmask[7:0] & cam_data[7:0]) & stb_cam_vld & ~scan_ena ;

				end	
	end

assign	byte_overlap_mx[7:0] =
	(cam_tid[1:0] == 2'b00) ? byte_overlap[7:0] :
		(cam_tid[1:0] == 2'b01) ? byte_overlap[15:8] :
			(cam_tid[1:0] == 2'b10) ? byte_overlap[23:16] :
				(cam_tid[1:0] == 2'b11) ? byte_overlap[31:24] : 8'bxxxx_xxxx ;

assign	byte_match_mx[7:0] =
	(cam_tid[1:0] == 2'b00) ? byte_match[7:0] :
		(cam_tid[1:0] == 2'b01) ? byte_match[15:8] :
			(cam_tid[1:0] == 2'b10) ? byte_match[23:16] :
				(cam_tid[1:0] == 2'b11) ? byte_match[31:24] : 8'bxxxx_xxxx ;

assign	ptag_hit_mx[7:0] =
	(cam_tid[1:0] == 2'b00) ? ptag_hit[7:0] :
		(cam_tid[1:0] == 2'b01) ? ptag_hit[15:8] :
			(cam_tid[1:0] == 2'b10) ? ptag_hit[23:16] :
				(cam_tid[1:0] == 2'b11) ? ptag_hit[31:24] : 8'bxxxx_xxxx ;

assign	stb_ld_full_raw[7:0] =  
	ptag_hit_mx[7:0] & byte_match_mx[7:0] & ~byte_overlap_mx[7:0] & ~sqsh_msk[7:0] ;
assign	stb_ld_partial_raw[7:0] =  
	ptag_hit_mx[7:0] & byte_match_mx[7:0] &  byte_overlap_mx[7:0] & ~sqsh_msk[7:0] ;

assign	cam_hit[7:0] = 
	ptag_hit_mx[7:0] & byte_match_mx[7:0] & ~sqsh_msk[7:0] ;
assign	stb_cam_hit = |(cam_hit[7:0]);

assign	stb_cam_hit_ptr[0] 	=  cam_hit[1] | cam_hit[3] | cam_hit[5] | cam_hit[7] ;
assign	stb_cam_hit_ptr[1] 	=  cam_hit[2] | cam_hit[3] | cam_hit[6] | cam_hit[7] ;
assign	stb_cam_hit_ptr[2] 	=  cam_hit[4] | cam_hit[5] | cam_hit[6] | cam_hit[7] ;

assign  stb_cam_mhit            =  (cam_hit[0]  & cam_hit[1]) | (cam_hit[2] & cam_hit[3])  |
                                   (cam_hit[4]  & cam_hit[5]) | (cam_hit[6] & cam_hit[7])  |
                                   ((cam_hit[0] | cam_hit[1]) & (cam_hit[2] | cam_hit[3])) |
                                   ((cam_hit[4] | cam_hit[5]) & (cam_hit[6] | cam_hit[7])) |
                                   ((|cam_hit[3:0]) & (|cam_hit[7:4]));

endmodule