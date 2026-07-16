//1128
module clk_div_module(
    src_clk             ,div_rst_n           ,div_clk_0           ,div_clk_1            );

    input               src_clk     ;input               div_rst_n   ;output              div_clk_0   ;output              div_clk_1   ;reg     [01:00]     clk_div_cnt     ;always @(posedge src_clk or negedge div_rst_n) begin : DIV_CNT_ADD
        if(!div_rst_n)
            begin
                `ifndef SYNTHESIS
                    $display("The initial value of clk div count is 0.");
                `endif
                clk_div_cnt     <= 'd0;
            end
        else
            begin
                clk_div_cnt     <= clk_div_cnt + 1'b1;
            end   
    end
    assign  div_clk_0   = clk_div_cnt[0];
    assign  div_clk_1   = clk_div_cnt[1];
    
    endmodule