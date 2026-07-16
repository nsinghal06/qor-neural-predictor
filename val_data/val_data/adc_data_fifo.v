//2
module adc_data_fifo (
    aclr,
    data,
    rdclk,
    rdreq,
    wrclk,
    wrreq,
    q,
    rdempty,
    wrfull
);

    parameter WIDTH = 12;
    parameter DEPTH = 16;

    input aclr;
    input [WIDTH-1:0] data;
    input rdclk;
    input rdreq;
    input wrclk;
    input wrreq;
    output [WIDTH-1:0] q;
    output rdempty;
    output wrfull;

    reg [DEPTH-1:0] wptr;
    reg [DEPTH-1:0] rptr;
    reg [WIDTH-1:0] mem [DEPTH-1:0];

    reg [WIDTH-1:0] q_reg;
    wire [WIDTH-1:0] q_next;

    assign rdempty = (wptr == rptr);
    assign wrfull = ((wptr + 1) % DEPTH == rptr);

    assign q_next = mem[rptr];

    always @(posedge aclr or posedge wrclk) begin
        if (aclr) begin
            wptr <= 0;
        end else if (wrclk & wrreq) begin
            mem[wptr] <= data;
            wptr <= (wptr + 1) % DEPTH;
        end
    end

    always @(posedge aclr or posedge rdclk) begin
        if (aclr) begin
            rptr <= 0;
        end else if (rdclk & rdreq & !rdempty) begin
            rptr <= (rptr + 1) % DEPTH;
        end
    end

    always @(posedge aclr or posedge rdclk) begin
        if (aclr)
            q_reg <= 0;
        else if (rdclk & rdreq & !rdempty)
            q_reg <= q_next;
    end

    assign q = q_reg;

endmodule