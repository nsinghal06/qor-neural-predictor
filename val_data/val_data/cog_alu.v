//1396
module              cog_alu
(
input        [5:0]  i,
input       [31:0]  s,
input       [31:0]  d,
input        [8:0]  p,
input               run,
input               ci,
input               zi,

input       [31:0]  bus_q,
input               bus_c,

output              wr,
output      [31:0]  r,
output              co,
output              zo
);


wire [31:0] dr      = { d[0],  d[1],  d[2],  d[3],  d[4],  d[5],  d[6],  d[7],
                        d[8],  d[9],  d[10], d[11], d[12], d[13], d[14], d[15],
                        d[16], d[17], d[18], d[19], d[20], d[21], d[22], d[23],
                        d[24], d[25], d[26], d[27], d[28], d[29], d[30], d[31] };

wire [255:0] ri     = { 32'b0,              {32{d[31]}},        {32{ci}},           {32{ci}},           32'b0,              32'b0,              dr[31:0],           d[31:0] };          wire [63:0] rot     = {ri[i[2:0]*32 +: 32], i[0] ? dr : d} >> s[4:0];

wire [31:0] rotr    = { rot[0],  rot[1],  rot[2],  rot[3],  rot[4],  rot[5],  rot[6],  rot[7],
                        rot[8],  rot[9],  rot[10], rot[11], rot[12], rot[13], rot[14], rot[15],
                        rot[16], rot[17], rot[18], rot[19], rot[20], rot[21], rot[22], rot[23],
                        rot[24], rot[25], rot[26], rot[27], rot[28], rot[29], rot[30], rot[31] };

wire [31:0] rot_r   = ~&i[2:1] && i[0] ? rotr : rot[31:0];

wire rot_c          = ~&i[2:1] && i[0] ? dr[0] : d[0];


wire [1:0] log_s    = i[2] ? {(i[1] ? zi : ci) ^ i[0], 1'b0}    : {i[1], ~^i[1:0]};                  wire [127:0] log_x  = { d ^  s,                                 d |  s,                                 d &  s,                                 d & ~s };                               wire [127:0] mov_x  = { d[31:9], p,                             s[8:0], d[22:0],                        d[31:18], s[8:0], d[8:0],               d[31:9], s[8:0] };                      wire [31:0] log_r   = i[3] ? log_x[log_s*32 +: 32]              : i[2] ? mov_x[i[1:0]*32 +: 32]             : s;                                 wire log_c          = ^log_r;                                   wire [3:0] ads      = {zi, ci, s[31], 1'b0};

wire add_sub        = i[5:4] == 2'b10           ? ads[i[2:1]] ^ i[0]    : i[5:0] == 6'b110010 ||                            i[5:0] == 6'b110100 ||                            i[5:0] == 6'b110110 ||                            i[5:2] == 4'b1111         ? 1'b0                  : 1'b1;                 wire add_ci         = i[5:3] == 3'b110 && (i[2:0] == 3'b001 || i[1]) && ci ||       i[4:3] == 2'b11 && i[1:0] == 2'b01;                           wire [31:0] add_d   = i[4:3] == 2'b01 ? 32'b0 : d;      wire [31:0] add_s   = i[4:0] == 5'b11001 || i[4:1] == 4'b1101   ? 32'hFFFFFFFF      : add_sub                                   ? ~s                : s;                wire [34:0] add_x   = {1'b0, add_d[31], 1'b1, add_d[30:0], 1'b1} +
                      {1'b0, add_s[31], 1'b0, add_s[30:0], add_ci ^ add_sub};

wire [31:0] add_r   = {add_x[33], add_x[31:1]};

wire add_co         = add_x[34];

wire add_cm         = !add_x[32];

wire add_cs         = add_co ^ add_d[31] ^ add_s[31];

wire add_c          = i[5:0] == 6'b111000       ? add_co                : i[5:3] == 3'b101          ? s[31]                 : i[5] && i[3:2] == 2'b01   ? add_co ^ add_cm       : i[4:1] == 4'b1000         ? add_cs                : add_co ^ add_sub;     assign wr           = i[5:2] == 4'b0100     ? i[0] ^ (i[1] ? !add_co : add_cs)      : i[5:0] == 6'b111000   ? add_co                                : 1'b1;                                 assign r            = i[5]                  ? add_r
                    : i[4]                  ? log_r
                    : i[3]                  ? rot_r
                    : run || ~&p[8:4]       ? bus_q
                                            : 32'b0;    assign co           = i[5:3] == 3'b000      ? bus_c
                    : i[5:3] == 3'b001      ? rot_c
                    : i[5:3] == 3'b011      ? log_c
                                            : add_c;

assign zo           = ~|r && (zi || !(i[5:3] == 3'b110 && (i[2:0] == 3'b001 || i[1])));     endmodule