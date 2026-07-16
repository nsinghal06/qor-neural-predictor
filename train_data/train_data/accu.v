//516
module accu(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_a     ,
    input               ready_b     ,
 
    output              ready_a     ,
    output  reg         valid_b     ,
    output  reg [9:0]   data_out
);

reg [9:0] acc_reg;
reg [2:0] stage;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        acc_reg <= 10'b0;
        stage <= 3'b0;
        valid_b <= 1'b0;
    end else begin
        case(stage)
            3'b000: begin
                if(valid_a) begin
                    acc_reg <= acc_reg + data_in;
                    stage <= 3'b001;
                end
            end
            3'b001: begin
                if(valid_a) begin
                    acc_reg <= acc_reg + data_in;
                    stage <= 3'b010;
                end else begin
                    stage <= 3'b000;
                end
            end
            3'b010: begin
                if(valid_a) begin
                    acc_reg <= acc_reg + data_in;
                    stage <= 3'b011;
                end else begin
                    stage <= 3'b000;
                end
            end
            3'b011: begin
                if(valid_a) begin
                    acc_reg <= acc_reg + data_in;
                    stage <= 3'b100;
                end else begin
                    stage <= 3'b000;
                end
            end
            3'b100: begin
                if(valid_a) begin
                    acc_reg <= acc_reg + data_in;
                    stage <= 3'b101;
                end else begin
                    stage <= 3'b000;
                end
            end
            3'b101: begin
                if(valid_a) begin
                    acc_reg <= acc_reg + data_in;
                    stage <= 3'b110;
                end else begin
                    stage <= 3'b000;
                end
            end
            3'b110: begin
                if(valid_a) begin
                    acc_reg <= acc_reg + data_in;
                    stage <= 3'b111;
                end else begin
                    stage <= 3'b000;
                end
            end
            3'b111: begin
                data_out <= acc_reg;
                valid_b <= 1'b1;
                stage <= 3'b000;
            end
        endcase
    end
end

assign ready_a = ~valid_b & ready_b;

endmodule