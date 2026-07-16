//671
module ternary_operator(
    input ready,
    input cond,
    input out_req,
    output reg out_ack,
    output reg [7:0] out_value,
    output reg out_value_valid,
    output reg false_req,
    input false_ack,
    input [7:0] false_value,
    input false_value_valid,
    output reg true_req,
    input true_ack,
    input [7:0] true_value,
    input true_value_valid
);

    always @(*) begin
        if (~ready) begin
            true_req = 1'b0;
            false_req = 1'b0;
            out_ack = 1'b0;
            out_value = 8'hFF;
            out_value_valid = 1'b0;
        end else if (cond) begin
            true_req = out_req;
            false_req = 1'b0;
            if (out_req && true_ack) begin
                out_value = true_value;
                out_value_valid = true_value_valid;
                out_ack = 1'b1;
            end else begin
                out_ack = 1'b0;
                out_value = 8'hFF;
                out_value_valid = 1'b0;
            end
        end else begin
            false_req = out_req;
            true_req = 1'b0;
            if (out_req && false_ack) begin
                out_value = false_value;
                out_value_valid = false_value_valid;
                out_ack = 1'b1;
            end else begin
                out_ack = 1'b0;
                out_value = 8'hFF;
                out_value_valid = 1'b0;
            end
        end
    end

endmodule