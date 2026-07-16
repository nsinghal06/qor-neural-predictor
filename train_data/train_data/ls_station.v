//1314
module ls_station(
     input clk, rst,
     
     input isDispatch,
     input [3:0] rob_num_dp,
     input [5:0] p_rd_new,            input [5:0] p_rs,
     input read_rs,                    input v_rs,                       input [5:0] p_rt,
     input read_rt,
     input v_rt,	 
     input mem_ren, mem_wen,  input [15:0] immed,

     input stall_hazard,
     input stall_issue,

     input recover,
     input [3:0] rob_num_rec,             input [5:0] p_rd_compl,              input RegDest_compl,
     input complete,

     output [5:0] p_rs_out, p_rt_out,
     output [5:0] p_rd_out,   output [15:0] immed_out,
     output [3:0] rob_num_out,
     output RegDest_out,       output mem_ren_out,       output mem_wen_out,        output issue,              output lss_full
);
    
reg [41:0] ls_station [0:3]; 
reg [3:0] lss_valid;          reg [2:0] counter; 
reg [3:0] head, tail; 
reg [1:0] head_addr; 

wire read, write;
wire head_rdy;    assign write = isDispatch && !stall_hazard && !lss_full && !recover && (mem_ren || mem_wen);
assign read = !stall_hazard && !recover && head_rdy && lss_valid[head_addr] && !stall_issue;   always @(posedge clk or negedge rst) begin
    if (!rst) 
        counter <= 3'b000;           
    else if (write && read)
        counter <= counter;
    else if (write)      
        counter <= counter + 1;
    else if (read)
        counter <= counter - 1;
end

assign lss_full = (counter == 3'b100);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        head <= 4'b0001;
        head_addr <= 2'b00;           
        tail <= 4'b0001;  
    end
    else begin
        if (write) begin     
            tail <= {tail[2:0], tail[3]};
		end
        if (read) begin
            head <= {head[2:0], head[3]};
            head_addr <= head_addr + 1;
        end			
   end
end

wire [3:0] rob_match_array;   wire [3:0] rs_match_array, rt_match_array;
genvar j;
generate 
for (j = 0; j < 4; j = j + 1) begin : combinational
    assign rob_match_array[j] = (ls_station[j][39:36] == rob_num_rec) && lss_valid[j];
    assign rs_match_array[j] = (ls_station[j][29:24] == p_rd_compl) && lss_valid[j] && RegDest_compl;
    assign rt_match_array[j] = (ls_station[j][22:17] == p_rd_compl) && lss_valid[j] && RegDest_compl;
end
endgenerate
						 

genvar i;
generate 
    for (i = 0; i < 4; i = i + 1) begin : sequential
        always @(posedge clk or negedge rst) begin
            if (!rst) begin
                ls_station[i] <= {42{1'b0}};
                lss_valid[i] <= 1'b0;
            end
            else begin
               if (write && tail[i]) begin ls_station[i] <= {mem_ren, mem_wen, rob_num_dp, p_rd_new, p_rs, v_rs || (!read_rs),
                                     p_rt, v_rt || (!read_rt), immed};
                   lss_valid[i] <= 1'b1;
               end
               else begin
                   if (recover && rob_match_array[i]) begin    ls_station[i][41:40] <= 2'b00;
                   end
                   if (complete && rs_match_array[i]) begin   ls_station[i][23] <= 1'b1;
                   end
                   if (complete && rt_match_array[i]) begin
                       ls_station[i][16] <= 1'b1;
                   end
                   if (read && head[i]) begin
                       lss_valid[i] <= 1'b0;
                   end
               end
            end
        end
    end
endgenerate

assign head_rdy = ls_station[head_addr][23] && ls_station[head_addr][16];
assign p_rs_out = ls_station[head_addr][29:24];
assign p_rt_out = ls_station[head_addr][22:17];
assign p_rd_out = ls_station[head_addr][35:30];
assign immed_out = ls_station[head_addr][15:0];
assign RegDest_out = ls_station[head_addr][41];   assign mem_ren_out = ls_station[head_addr][41];   assign mem_wen_out = ls_station[head_addr][40];   assign rob_num_out = ls_station[head_addr][39:36];
assign issue = read;
endmodule