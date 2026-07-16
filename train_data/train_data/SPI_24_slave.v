//1080
module SPI_24_slave(
	input       		clk,              input					SCK, 					input					SSEL, 				input					MOSI,					output				MISO,             input					data_ready,			input			[7:0] DataOut,				output reg	[7:0] DataIn,				output reg	[4:0] KeyPad,				output		[3:0] OutSel,           output		[3:0] InSel,            output				KEY,					output				RST,              output				SEL,              output reg			kbd_received,     output reg			pnl_received,     output reg			data_received,    output				SPI_Start,        output				SPI_Active,       output				SPI_End           );

assign OutSel = Panel[3:0];
assign InSel  = Panel[7:4];
assign KEY 	  = Panel[8  ];
assign RST    = Panel[9  ];
assign SEL    = Panel[10 ];

reg [2:0] DRedge;  
always @(posedge clk) DRedge <= {DRedge[1:0], data_ready};
wire DR_risingedge  = (DRedge[2:1] == 2'b01);      reg [2:0] SCKr;  
always @(posedge clk) SCKr <= {SCKr[1:0], SCK};
wire SCK_risingedge  = (SCKr[2:1] == 2'b01);      reg [2:0] SSELr;  
always @(posedge clk) SSELr <= {SSELr[1:0], SSEL};
assign SPI_Active  = ~SSELr[1];              assign SPI_Start   = (SSELr[2:1] == 2'b10);  assign SPI_End     = (SSELr[2:1] == 2'b01);  reg [1:0] MOSIr;  
always @(posedge clk) MOSIr <= {MOSIr[0], MOSI};
wire MOSI_data = MOSIr[1];

reg   [4:0] bitcnt;                         reg  [10:0] Panel;                          reg   [7:0] databits;                       wire        rcv_addr  = (bitcnt > 5'd4);    wire        rcv_data  = (bitcnt > 5'd15);   assign      MISO = rcv_data ? databits[7] : 1'b0;     always @(posedge clk) begin
    if(DR_risingedge) databits <= DataOut;  if(~SPI_Active) begin                   bitcnt   <=  5'h00;                 databits <=  8'h00;                 end
    else begin         
        if(SCK_risingedge) begin
            bitcnt <= bitcnt + 5'd1;        if(rcv_data) begin
                DataIn   <= {DataIn[6:0], MOSI_data};     databits <= {databits[6:0], 1'b0};        end
            else begin
                if(rcv_addr) Panel   <= {Panel[9:0], MOSI_data};    else         KeyPad  <= {KeyPad[3:0], MOSI_data};   end
        end
    end
end

always @(posedge clk) begin
    kbd_received  <= SPI_Active && SCK_risingedge && (bitcnt == 5'd4 );
    pnl_received  <= SPI_Active && SCK_risingedge && (bitcnt == 5'd15);
    data_received <= SPI_Active && SCK_risingedge && (bitcnt == 5'd23);
end

endmodule