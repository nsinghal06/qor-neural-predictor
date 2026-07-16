//1290
module GTX_DRP_CHANALIGN_FIX_3752_V6
#(
  parameter       TCQ             = 1,
  parameter       C_SIMULATION    = 0 )
(
  output  reg          dwe,
  output  reg  [15:0]  din,    output  reg          den,
  output  reg  [7:0]   daddr,
  output  reg  [3:0]   drpstate,
  input                write_ts1,
  input                write_fts,
  input       [15:0]   dout,  input                drdy,
  input                Reset_n,
  input                drp_clk

);


  reg  [7:0]     next_daddr;
  reg  [3:0]     next_drpstate;



  reg            write_ts1_gated;
  reg            write_fts_gated;


  localparam      DRP_IDLE_FTS           =  1;
  localparam      DRP_IDLE_TS1           =  2;
  localparam      DRP_RESET              =  3;
  localparam      DRP_WRITE_FTS          =  6;
  localparam      DRP_WRITE_DONE_FTS     =  7;
  localparam      DRP_WRITE_TS1          =  8;
  localparam      DRP_WRITE_DONE_TS1     =  9;
  localparam      DRP_COM                = 10'b0110111100;
  localparam      DRP_FTS                = 10'b0100111100;
  localparam      DRP_TS1                = 10'b0001001010;


  always @(posedge drp_clk) begin

    if ( ~Reset_n ) begin

      daddr     <= #(TCQ) 8'h8;
      drpstate  <= #(TCQ) DRP_RESET;


      write_ts1_gated <= #(TCQ) 0;
      write_fts_gated <= #(TCQ) 0;

    end else begin

      daddr     <= #(TCQ) next_daddr;
      drpstate  <= #(TCQ) next_drpstate;



      write_ts1_gated <= #(TCQ) write_ts1;
      write_fts_gated <= #(TCQ) write_fts;

    end

  end


  always @(*) begin

    next_drpstate=drpstate;
    next_daddr=daddr;
    den=0;
    din=0;
    dwe=0;

    case(drpstate)

      DRP_RESET : begin

        next_drpstate= DRP_WRITE_TS1;
        next_daddr=8'h8;

      end



      DRP_WRITE_FTS : begin

        den=1;
        dwe=1;
        case (daddr)
          8'h8 : din = 16'hFD3C;
          8'h9 : din = 16'hC53C;
          8'hA : din = 16'hFDBC;
          8'hB : din = 16'h853C;
        endcase
        next_drpstate=DRP_WRITE_DONE_FTS;

      end

      DRP_WRITE_DONE_FTS : begin

        if(drdy) begin

          if(daddr==8'hB) begin

            next_drpstate=DRP_IDLE_FTS;
            next_daddr=8'h8;

          end else begin

            next_drpstate=DRP_WRITE_FTS;
            next_daddr=daddr+1'b1;

          end

        end

      end

      DRP_IDLE_FTS : begin

        if(write_ts1_gated) begin

          next_drpstate=DRP_WRITE_TS1;
          next_daddr=8'h8;

        end

      end

      DRP_WRITE_TS1 : begin
        den=1;
        dwe=1;
        case (daddr)
          8'h8 : din = 16'hFC4A;
          8'h9 : din = 16'hDC4A;
          8'hA : din = 16'hC04A;
          8'hB : din = 16'h85BC;
        endcase
        next_drpstate=DRP_WRITE_DONE_TS1;

      end

      DRP_WRITE_DONE_TS1 : begin

        if(drdy) begin

          if(daddr==8'hB) begin

            next_drpstate=DRP_IDLE_TS1;
            next_daddr=8'h8;

          end else begin

            next_drpstate=DRP_WRITE_TS1;
            next_daddr=daddr+1'b1;

          end

        end

      end

      DRP_IDLE_TS1 : begin

        if(write_fts_gated) begin

          next_drpstate=DRP_WRITE_FTS;
          next_daddr=8'h8;

        end

      end

    endcase

  end

endmodule