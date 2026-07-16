//342
module soc_system_sysid_qsys (
  // inputs:
  address,
  clock,
  reset_n,

  // outputs:
  readdata
);

  output  [31:0] readdata;
  input            address;
  input            clock;
  input            reset_n;

  reg [31:0] readdata;

  reg [31:0] readdata_zero = 2899645186;
  reg [31:0] readdata_one = 1390537961;

  always @(posedge clock or negedge reset_n) begin
    if (!reset_n) begin
      readdata <= 32'b0;
    end else begin
      if (address == 0) begin
        readdata <= readdata_zero;
      end else begin
        readdata <= readdata_one;
      end
    end
  end

endmodule