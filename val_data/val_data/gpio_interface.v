//50
module gpio_interface (
    input s_axi_aclk,
    input bus2ip_cs,
    input bus2ip_rnw,
    input [7:0] gpio_io_t,
    output [7:0] gpio_io_o,
    output reg ip2bus_rdack_i,
    output reg ip2bus_wrack_i_D1_reg,
    output reg GPIO_xferAck_i
);

    reg [7:0] gpio_io_o_reg;
    reg [7:0] gpio_io_t_reg;

    always @(posedge s_axi_aclk) begin
        if (bus2ip_rnw) begin
            gpio_io_t_reg <= {8{1'b0}};
        end else begin
            gpio_io_t_reg <= gpio_io_t;
        end
    end

    always @(posedge s_axi_aclk) begin
        if (bus2ip_rnw) begin
            gpio_io_o_reg <= gpio_io_o_reg;
        end else begin
            gpio_io_o_reg <= gpio_io_o;
        end
    end

    always @(posedge s_axi_aclk) begin
        if (bus2ip_cs) begin
            ip2bus_rdack_i <= 1'b1;
            ip2bus_wrack_i_D1_reg <= 1'b1;
            GPIO_xferAck_i <= 1'b1;
        end else begin
            ip2bus_rdack_i <= 1'b0;
            ip2bus_wrack_i_D1_reg <= 1'b0;
            GPIO_xferAck_i <= 1'b0;
        end
    end

    assign gpio_io_o = gpio_io_o_reg;

endmodule