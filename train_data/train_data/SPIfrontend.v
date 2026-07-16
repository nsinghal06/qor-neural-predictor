//984
module SPIfrontend(nCS, CLK, MOSI, MISO, inbyte, outbyte, out_valid, mode, busy);
   input nCS;
   input CLK;
   input MOSI;
   input [1:0] mode;
   output reg MISO; // Three-state MISO output pin
   output reg busy; // Busy indication
   
   input [7:0] inbyte;
   output reg [7:0] outbyte; // Double-buffered output byte
   output reg out_valid; // Output byte validity flag

   reg [2:0] bitcnt = 3'b0; // Bit position counter

   always @(posedge nCS or posedge CLK) begin // 'reset' condition
     
      if (nCS) begin
         bitcnt <= 0;
         outbyte <= 0;
         busy <= 0;
         out_valid <= 0;
      end
      else if (!nCS) begin
         case (mode)
            2'b00: begin // Normal SPI mode
               MISO <= inbyte[bitcnt];
               outbyte <= 0;
               busy <= 1;
               if(bitcnt == 7) bitcnt <= 0; else bitcnt <= bitcnt + 1;
            end
            2'b01: begin // Read mode
               MISO <= inbyte;
               outbyte <= 0;
               bitcnt <= 0;
               busy <= 1;
            end
            2'b10: begin // Write mode
               MISO <= 0;
               if (bitcnt < 8) begin
                  outbyte[bitcnt] <= MOSI;
                  bitcnt <= bitcnt + 1;
                  busy <= 1;
               end
               else begin
                  busy <= 0;
                  out_valid <= 1;
               end
            end
         endcase
      end
   end // always @ (posedge nCS or posedge CLK)
   
endmodule