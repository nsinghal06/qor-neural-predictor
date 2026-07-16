//139
module pixel_scaler (
    // Inputs
    input clk,
    input reset,

    input [DW:0] stream_in_data,
    input stream_in_startofpacket,
    input stream_in_endofpacket,
    input stream_in_empty,
    input stream_in_valid,

    // Outputs
    output stream_out_ready,

    // Outputs
    output stream_in_ready,

    output [DW:0] stream_out_data,
    output stream_out_startofpacket,
    output stream_out_endofpacket,
    output stream_out_empty,
    output stream_out_valid
);

    parameter DW = 29; // Frame's Data Width
    parameter EW = 1; // Frame's Empty Width

    parameter WIW = 8; // Incoming frame's width's address width
    parameter HIW = 7; // Incoming frame's height's address width
    parameter WIDTH_IN = 320;

    parameter WIDTH_DROP_MASK = 4'b0000;
    parameter HEIGHT_DROP_MASK = 4'b0000;

    parameter MH_WW = 8; // Multiply height's incoming width's address width
    parameter MH_WIDTH_IN = 320; // Multiply height's incoming width
    parameter MH_CW = 6; // Multiply height's counter width

    parameter MW_CW = 6; // Multiply width's counter width

    // Internal wires and registers
    reg [DW:0] internal_data;
    reg internal_startofpacket;
    reg internal_endofpacket;
    reg internal_valid;
    reg internal_ready;

    // Pixel dropping logic
    wire [WIW-1:0] in_width;
    wire [HIW-1:0] in_height;
    wire [WIW-1:0] out_width;
    wire [HIW-1:0] out_height;
    wire [DW:0] pixel_data;
    wire [EW:0] pixel_empty;
    wire pixel_startofpacket;
    wire pixel_endofpacket;
    wire pixel_valid;
    wire pixel_ready;

    assign in_width = stream_in_data[WIW-1:0];
    assign in_height = stream_in_data[WIW+HIW-1:WIW];

    assign out_width = in_width - WIDTH_DROP_MASK;
    assign out_height = in_height - HEIGHT_DROP_MASK;

    assign pixel_data = stream_in_data;
    assign pixel_empty = stream_in_empty;
    assign pixel_startofpacket = stream_in_startofpacket;
    assign pixel_endofpacket = stream_in_endofpacket;
    assign pixel_valid = stream_in_valid;
    assign pixel_ready = internal_ready;

    always @ (posedge clk) begin
        if (reset) begin
            internal_data <= 0;
            internal_startofpacket <= 0;
            internal_endofpacket <= 0;
            internal_valid <= 0;
            internal_ready <= 0;
        end else begin
            if (pixel_valid && pixel_ready) begin
                internal_data <= pixel_data;
                internal_startofpacket <= pixel_startofpacket;
                internal_endofpacket <= pixel_endofpacket;
                internal_valid <= pixel_valid;
                internal_ready <= pixel_ready;
            end else begin
                internal_ready <= 1;
            end
        end
    end

    // Height multiplication logic
    wire [MH_WW-1:0] height_mult;
    reg [MH_CW-1:0] height_mult_count;
    wire [HIW-1:0] in_height_mult;
    wire [HIW-1:0] out_height_mult;
    wire [DW:0] pixel_data_mult;
    wire [EW:0] pixel_empty_mult;
    wire pixel_startofpacket_mult;
    wire pixel_endofpacket_mult;
    wire pixel_valid_mult;
    wire pixel_ready_mult;

    assign height_mult = { {MH_WW{1'b0}}, stream_in_data[WIW+HIW-1:WIW] };
    assign in_height_mult = stream_in_data[WIW+HIW-1:WIW];
    assign out_height_mult = in_height_mult * height_mult_count;
    assign pixel_data_mult = { stream_in_data[DW], out_height_mult, stream_in_data[WIW-1:0] };
    assign pixel_empty_mult = stream_in_empty;
    assign pixel_startofpacket_mult = stream_in_startofpacket;
    assign pixel_endofpacket_mult = stream_in_endofpacket;
    assign pixel_valid_mult = stream_in_valid;
    assign pixel_ready_mult = internal_ready;

    always @ (posedge clk) begin
        if (reset) begin
            height_mult_count <= 0;
        end else begin
            if (pixel_valid_mult && pixel_ready_mult) begin
                height_mult_count <= height_mult_count + 1;
            end
        end
    end

    // Width multiplication logic
    reg [MW_CW-1:0] width_mult_count;
    wire [WIW-1:0] in_width_mult;
    wire [WIW-1:0] out_width_mult;
    wire [DW:0] pixel_data_mult_w;
    wire [EW:0] pixel_empty_mult_w;
    wire pixel_startofpacket_mult_w;
    wire pixel_endofpacket_mult_w;
    wire pixel_valid_mult_w;
    wire pixel_ready_mult_w;

    assign in_width_mult = stream_in_data[WIW-1:0];
    assign out_width_mult = in_width_mult * 2**width_mult_count;
    assign pixel_data_mult_w = { stream_in_data[DW], stream_in_data[WIW+HIW-1:WIW], out_width_mult };
    assign pixel_empty_mult_w = stream_in_empty;
    assign pixel_startofpacket_mult_w = stream_in_startofpacket;
    assign pixel_endofpacket_mult_w = stream_in_endofpacket;
    assign pixel_valid_mult_w = stream_in_valid;
    assign pixel_ready_mult_w = internal_ready;

    always @ (posedge clk) begin
        if (reset) begin
            width_mult_count <= 0;
        end else begin
            if (pixel_valid_mult_w && pixel_ready_mult_w) begin
                width_mult_count <= width_mult_count + 1;
            end
        end
    end

    // Output assignments
    assign stream_out_ready = internal_ready;

    assign stream_in_ready = internal_ready;

    assign stream_out_data = internal_data;
    assign stream_out_startofpacket = internal_startofpacket;
    assign stream_out_endofpacket = internal_endofpacket;
    assign stream_out_valid = internal_valid;
    assign stream_out_empty = 0;

endmodule