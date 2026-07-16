//1413
module spi_receiver (
  // system signals
  input  wire        clk,
  input  wire        rst,
  // SPI signals
  input  wire        spi_sclk,
  input  wire        spi_mosi,
  input  wire        spi_cs_n,
  //
  input  wire        transmitting,
  output reg   [7:0] opcode,
  output reg  [31:0] opdata,
  output reg         execute
);

localparam READOPCODE = 1'h0;
localparam READLONG   = 1'h1;

reg state, next_state;			// receiver state
reg [1:0] bytecount, next_bytecount;	// count rxed bytes of current command
reg [7:0] next_opcode;		// opcode byte
reg [31:0] next_opdata;	// data dword
reg next_execute;

reg [2:0] bitcount, next_bitcount;	// count rxed bits of current byte
reg [7:0] spiByte, next_spiByte;
reg byteready, next_byteready;

wire cs_negedge;
wire sclk_posedge;
wire sampled_mosi;

reg dly_sclk;
reg dly_cs;

initial bitcount = 0;
always @(posedge clk, posedge rst)
if (rst) bitcount <= 0;
else     bitcount <= next_bitcount;

always @(posedge clk)
begin
  spiByte   <= next_spiByte;
  byteready <= next_byteready;
end

always @*
begin
  next_bitcount = bitcount;
  next_spiByte = spiByte;
  next_byteready = 1'b0;

  if (cs_negedge)
    next_bitcount = 0;

  if (sclk_posedge) // detect rising edge of sclk
    if (spi_cs_n)
      begin
        next_bitcount = 0;
        next_spiByte = 0;
      end
    else
      if (bitcount == 7)
        begin
          next_bitcount = 0;
          next_byteready = 1;
          next_spiByte = {spiByte[6:0], sampled_mosi};
        end
      else
        begin
          next_bitcount = bitcount + 1'b1;
          next_spiByte = {spiByte[6:0], sampled_mosi};
        end
end

initial state = READOPCODE;
always @(posedge clk, posedge rst) 
if (rst)  state <= READOPCODE;
else      state <= next_state;

initial opcode = 0;
initial opdata = 0;
always @(posedge clk) 
begin
  bytecount <= next_bytecount;
  opcode    <= next_opcode;
  opdata    <= next_opdata;
  execute   <= next_execute;
end

always @*
begin
  next_state = state;
  next_bytecount = bytecount;
  next_opcode = opcode;
  next_opdata = opdata;
  next_execute = 1'b0;

  case (state)
    READOPCODE : // receive byte
      begin
	next_bytecount = 0;
	if (byteready)
	  begin
	    next_opcode = spiByte;
	    if (spiByte[7])
	      next_state = READLONG;
	    else // short command
	      begin
		next_execute = 1'b1;
	  	next_state = READOPCODE;
	      end
	  end
      end

    READLONG : // receive 4 word parameter
      begin
	if (byteready)
	  begin
	    next_bytecount = bytecount + 1'b1;
	    next_opdata = {spiByte,opdata[31:8]};
	    if (&bytecount) // execute long command
	      begin
		next_execute = 1'b1;
	  	next_state = READOPCODE;
	      end
	  end
      end
  endcase
end

assign cs_negedge = dly_cs && !spi_cs_n;
assign sclk_posedge = dly_sclk && !spi_sclk;
assign sampled_mosi = transmitting ? spi_mosi : 1'b0;

always @(posedge clk)
begin
  dly_sclk <= spi_sclk;
  dly_cs <= spi_cs_n;
end

endmodule