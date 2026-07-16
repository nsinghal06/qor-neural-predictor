//55
module simple_pic (
    input             clk,
    input             rst,
    input       [7:0] intv,
    input             inta,
    output            intr,
    output reg  [2:0] iid
  );

  reg       inta_r;
  reg [7:0] irr;
  reg [7:0] int_r;

  // Calculate the interrupt request register (irr)
  always @(posedge clk) begin
    if (rst) begin
      irr <= 8'b0;
    end else begin
      irr <= {intv[0] & !int_r[0], intv[1] & !int_r[1], intv[2] & !int_r[2], intv[3] & !int_r[3],
              intv[4] & !int_r[4], intv[5] & !int_r[5], intv[6] & !int_r[6], intv[7] & !int_r[7]} | (irr & ~{1'b0, inta_r & !inta, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0});
    end
  end

  // Calculate the interrupt pending signal (intr)
  assign intr = |irr;

  // Calculate the interrupt ID (iid)
  always @(posedge clk) begin
    if (rst) begin
      iid <= 3'b0;
    end else begin
      if (inta) begin
        iid <= iid;
      end else begin
        casez(irr)
          8'b0000_0001: iid <= 3'b000;
          8'b0000_0010: iid <= 3'b001;
          8'b0000_0100: iid <= 3'b010;
          8'b0000_1000: iid <= 3'b011;
          8'b0001_0000: iid <= 3'b100;
          8'b0010_0000: iid <= 3'b101;
          8'b0100_0000: iid <= 3'b110;
          8'b1000_0000: iid <= 3'b111;
          default: iid <= iid;
        endcase
      end
    end
  end

  // Calculate the interrupt request register for int0
  always @(posedge clk) begin
    if (rst) begin
      int_r[0] <= 1'b0;
    end else begin
      if (inta && inta_r && (iid == 3'b000)) begin
        int_r[0] <= 1'b0;
      end else begin
        int_r[0] <= intv[0];
      end
    end
  end

  // Calculate the interrupt request register for int1
  always @(posedge clk) begin
    if (rst) begin
      int_r[1] <= 1'b0;
    end else begin
      if (inta && inta_r && (iid == 3'b001)) begin
        int_r[1] <= 1'b0;
      end else begin
        int_r[1] <= intv[1];
      end
    end
  end

  // Calculate the interrupt request register for int2
  always @(posedge clk) begin
    if (rst) begin
      int_r[2] <= 1'b0;
    end else begin
      if (inta && inta_r && (iid == 3'b010)) begin
        int_r[2] <= 1'b0;
      end else begin
        int_r[2] <= intv[2];
      end
    end
  end

  // Calculate the interrupt request register for int3
  always @(posedge clk) begin
    if (rst) begin
      int_r[3] <= 1'b0;
    end else begin
      if (inta && inta_r && (iid == 3'b011)) begin
        int_r[3] <= 1'b0;
      end else begin
        int_r[3] <= intv[3];
      end
    end
  end

  // Calculate the interrupt request register for int4
  always @(posedge clk) begin
    if (rst) begin
      int_r[4] <= 1'b0;
    end else begin
      if (inta && inta_r && (iid == 3'b100)) begin
        int_r[4] <= 1'b0;
      end else begin
        int_r[4] <= intv[4];
      end
    end
  end

  // Calculate the interrupt request register for int5
  always @(posedge clk) begin
    if (rst) begin
      int_r[5] <= 1'b0;
    end else begin
      if (inta && inta_r && (iid == 3'b101)) begin
        int_r[5] <= 1'b0;
      end else begin
        int_r[5] <= intv[5];
      end
    end
  end

  // Calculate the interrupt request register for int6
  always @(posedge clk) begin
    if (rst) begin
      int_r[6] <= 1'b0;
    end else begin
      if (inta && inta_r && (iid == 3'b110)) begin
        int_r[6] <= 1'b0;
      end else begin
        int_r[6] <= intv[6];
      end
    end
  end

  // Calculate the interrupt request register for int7
  always @(posedge clk) begin
    if (rst) begin
      int_r[7] <= 1'b0;
    end else begin
      if (inta && inta_r && (iid == 3'b111)) begin
        int_r[7] <= 1'b0;
      end else begin
        int_r[7] <= intv[7];
      end
    end
  end

  // Capture the interrupt acknowledge signal (inta)
  always @(posedge clk) begin
    inta_r <= inta;
  end

endmodule