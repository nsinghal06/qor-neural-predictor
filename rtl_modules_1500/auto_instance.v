//1275
module auto_instance #(
    parameter WIDTH = 1
)(
    input clk,
    input rst,
    input [WIDTH-1:0] data_in,
    output [WIDTH-1:0] data_out,
    input enable
);

    // Internal signals
    wire [WIDTH-1:0] data_internal;

    // Instantiate submodules
    generate
        genvar i;
        for (i = 0; i < WIDTH; i = i + 1) begin : instance_loop
            a_entity inst_aa (
                .clk(clk),
                .rst(rst),
                .data_in(data_in[i]),
                .data_out(data_internal[i]),
                .enable(enable)
            );
        end
    endgenerate

    // Output assignments
    assign data_out = data_internal;

endmodule

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