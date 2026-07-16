//566
module der_reg_2
	(
	input		  de_clk,	input	   	  de_rstn,		input 	  	  load_actvn,	input 	  	  cmdcpyclr,    input [12:0] 	  buf_ctrl_1,   input [31:0] 	  sorg_1,       input [31:0] 	  dorg_1,       input [11:0] 	  sptch_1,      input [11:0] 	  dptch_1,      input [3:0] 	  opc_1,        input [3:0] 	  rop_1,        input [4:0] 	  style_1,      input 	   	  nlst_1,       input [1:0] 	  apat_1,       input [2:0] 	  clp_1,        input [31:0] 	  fore_1,       input [31:0] 	  back_1,       input [3:0] 	  mask_1,       input [23:0] 	  de_key_1,     input [15:0] 	  alpha_1,      input [17:0] 	  acntrl_1,     input [1:0] 	  bc_lvl_1,  

	output     [12:0] buf_ctrl_2,   output reg [31:0] sorg_2,       output reg [31:0] dorg_2,       output reg [11:0] sptch_2,      output reg [11:0] dptch_2,      output reg [3:0]  rop_2,        output reg [4:0]  style_2,      output reg 	  nlst_2,       output reg [1:0]  apat_2,       output reg [2:0]  clp_2,        output reg [31:0] fore_2,       output reg [31:0] back_2,       output reg [3:0]  mask_2,       output reg [23:0] de_key_2,     output reg [15:0] alpha_2,      output reg [17:0]  acntrl_2,     output reg [1:0]  bc_lvl_2,
	output reg [3:0]  opc_2
	);
  
  reg [12:0] 	   buf_ctrl_r;     
  
  
  
  
  assign 	   buf_ctrl_2 = {
	  			buf_ctrl_r[12:4],
				(buf_ctrl_r[3] | (buf_ctrl_r[2] & buf_ctrl_r[0])),
				 buf_ctrl_r[2:0]
				 };
  
  
  
  
  
  
  
  
  
  
  
  wire [1:0] 	   psize;
  reg [31:0] 	   fore_rep;
  reg [31:0] 	   back_rep;
  assign 	   psize = buf_ctrl_1[8:7];
  
  always @*
    casex (psize)
      2'b00: begin
	fore_rep = {4{fore_1[7:0]}}; 
	back_rep = {4{back_1[7:0]}};
      end
      2'bx1: begin
	fore_rep = {2{fore_1[15:0]}}; 
	back_rep = {2{back_1[15:0]}};
      end
      default: begin
	fore_rep = fore_1; 
	back_rep = back_1;
      end
    endcase always @(posedge de_clk, negedge de_rstn) begin
    if(!de_rstn)         opc_2 <= 4'b0;
    else if(cmdcpyclr)   opc_2 <= 4'b0;
    else if(!load_actvn) opc_2 <= opc_1;
  end


  always @(posedge de_clk or negedge de_rstn) begin
    if(!de_rstn) begin
      buf_ctrl_r  <= 13'b0;
      sorg_2      <= 32'b0;
      dorg_2      <= 32'b0;
      rop_2       <= 4'b0;
      style_2     <= 5'b0;
      nlst_2      <= 1'b0;
      apat_2      <= 2'b0;
      clp_2       <= 3'b0;
      bc_lvl_2    <= 2'b0;
      sptch_2     <= 12'b0;
      dptch_2     <= 12'b0;
      fore_2      <= 32'b0;
      back_2      <= 32'b0;
      mask_2      <= 4'b0;
      de_key_2    <= 24'b0;
      alpha_2     <= 16'b0;
      acntrl_2    <= 18'b0;
    end else if(!load_actvn) begin
      buf_ctrl_r  <= buf_ctrl_1;
      sorg_2      <= sorg_1;
      dorg_2      <= dorg_1;
      rop_2       <= rop_1;
      style_2     <= style_1;
      nlst_2      <= nlst_1;
      apat_2      <= apat_1;
      clp_2       <= clp_1;
      bc_lvl_2    <= bc_lvl_1;
      sptch_2     <= sptch_1;
      dptch_2     <= dptch_1;
      fore_2      <= fore_rep; 
      back_2      <= back_rep;
      mask_2      <= mask_1;
      de_key_2    <= de_key_1;
      alpha_2     <= alpha_1;
      acntrl_2    <= acntrl_1;
    end
  end
  
endmodule