//320
module sctag_dirl_buf(
   // Outputs
   output [7:0] lkup_en_c4_buf,
   output inval_mask_c4_buf,
   output [7:0] rw_dec_c4_buf,
   output rd_en_c4_buf,
   output wr_en_c4_buf,
   output rw_entry_c4_buf,
   output [7:0] lkup_wr_data_c4_buf,
   output dir_clear_c4_buf,
   // Inputs
   input rd_en_c4,
   input wr_en_c4,
   input inval_mask_c4,
   input [1:0] rw_row_en_c4,
   input [1:0] rw_panel_en_c4,
   input rw_entry_c4,
   input [1:0] lkup_row_en_c4,
   input [1:0] lkup_panel_en_c4,
   input [7:0] lkup_wr_data_c4,
   input dir_clear_c4
   );

   // Assigning values to the output signals
   assign inval_mask_c4_buf = inval_mask_c4 ;
   assign rd_en_c4_buf = rd_en_c4 ;
   assign wr_en_c4_buf = wr_en_c4 ;
   assign rw_entry_c4_buf = rw_entry_c4 ;
   assign lkup_wr_data_c4_buf = lkup_wr_data_c4 ;

   // Assigning values to the lkup_en_c4_buf signal
   assign lkup_en_c4_buf[0] = lkup_row_en_c4[0] & lkup_panel_en_c4[0] ;
   assign lkup_en_c4_buf[1] = lkup_row_en_c4[0] & lkup_panel_en_c4[1] ;
   assign lkup_en_c4_buf[2] = lkup_row_en_c4[1] & lkup_panel_en_c4[0] ;
   assign lkup_en_c4_buf[3] = lkup_row_en_c4[1] & lkup_panel_en_c4[1] ;
   assign lkup_en_c4_buf[4] = {1'b0, lkup_row_en_c4[0]};
   assign lkup_en_c4_buf[5] = {1'b0, lkup_row_en_c4[1]};
   assign lkup_en_c4_buf[6] = {1'b0,rw_row_en_c4[0]};
   assign lkup_en_c4_buf[7] = {1'b0,rw_row_en_c4[1]};

   // Assigning values to the dir_clear_c4_buf signal
   assign dir_clear_c4_buf = dir_clear_c4 ;

   // Assigning values to the rw_dec_c4_buf signal
   assign rw_dec_c4_buf[0] = rw_row_en_c4[0] & rw_panel_en_c4[0] ;
   assign rw_dec_c4_buf[1] = rw_row_en_c4[0] & rw_panel_en_c4[1] ;
   assign rw_dec_c4_buf[2] = rw_row_en_c4[1] & rw_panel_en_c4[0] ;
   assign rw_dec_c4_buf[3] = rw_row_en_c4[1] & rw_panel_en_c4[1] ;
   assign rw_dec_c4_buf[4] = {1'b0, rw_row_en_c4[0]};
   assign rw_dec_c4_buf[5] = {1'b0, rw_row_en_c4[1]};
   assign rw_dec_c4_buf[6] = {1'b0,rw_row_en_c4[0]};
   assign rw_dec_c4_buf[7] = {1'b0,rw_row_en_c4[1]};

endmodule