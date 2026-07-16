//700
module stack
(
    input clk,
    input [15:0] d,
    input [9:0] a,
    input we,
    output reg [15:0] spo
);

    wire [9:0] ram_a;
    wire [15:0] ram_d;
    wire [15:0] ram_spo;
    wire ram_we;

    assign ram_a = a;
    assign ram_d = d;
    assign ram_we = we;

    ram ram_inst
    (
        .clk(clk),
        .d(ram_d),
        .a(ram_a),
        .we(ram_we),
        .spo(ram_spo)
    );

    reg [9:0] sp;
    reg [15:0] stack [0:1023];

    always @(posedge clk) begin
        if (we) begin
            sp <= sp + 1;
            stack[sp] <= d;
        end else if (sp > 0) begin
            sp <= sp - 1;
        end
    end

    always @(posedge clk) begin
        if (sp > 0) begin
            spo <= stack[sp];
        end else begin
            spo <= 0;
        end
    end

endmodule

module ram
(
    input clk,
    input [15:0] d,
    input [9:0] a,
    input we,
    output reg [15:0] spo
);

    reg [15:0] mem [0:1023];

    always @(posedge clk) begin
        if (we) begin
            mem[a] <= d;
        end
        spo <= mem[a];
    end

endmodule