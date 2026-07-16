module a_entity (
    input clk,
    input rst,
    input data_in,
    output data_out,
    input enable
);

    // Internal signals
    reg data_internal;

    // Register data
    always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            data_internal <= 0;
        end else if (enable == 1) begin
            data_internal <= data_in;
        end
    end

    // Output assignments
    assign data_out = data_internal;

endmodule