//1205
module mips_div_stage #(
                       parameter WIDTH=32,
                       parameter STAGE=4
                       )

                       (
                       input[WIDTH-1:0]   a,
                       input[WIDTH-1:0]   b,
                       input[WIDTH-1:0]   remainder_in,

                       output[WIDTH-1:0]  quotient_out,
                       output[WIDTH-1:0]  remainder_out
                       );




  wire[WIDTH:0]       result_temp[WIDTH:0];
  wire[(WIDTH*2)-1:0] qr[WIDTH:0];
  wire[WIDTH:0]       divisor;




  assign qr[WIDTH]={remainder_in,a[WIDTH-1:0]};
  assign divisor={1'b0,b[WIDTH-1:0]};

  generate
  genvar gi;

  for(gi=WIDTH;gi>(WIDTH-STAGE);gi=gi-1)
    begin:gen
    assign result_temp[gi-1]= qr[gi][(WIDTH*2)-1:WIDTH-1]-divisor;
    assign qr[gi-1]=  result_temp[gi-1][WIDTH] ? {qr[gi][(WIDTH*2)-2:0],1'd0} :
                      {result_temp[gi-1][WIDTH-1:0],qr[gi][WIDTH-2:0],1'd1};
    end

  endgenerate

  assign quotient_out[WIDTH-1:0]= qr[WIDTH-STAGE][WIDTH-1:0];
  assign remainder_out[WIDTH-1:0]= qr[WIDTH-STAGE][(2*WIDTH)-1:WIDTH];




endmodule