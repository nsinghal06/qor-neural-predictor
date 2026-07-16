//351
module branch_predictor (
  input clock, reset, enable, taken_i,
  output prediction_o
);

  reg [1:0] STATE_reg;
  wire N11, N12, n5, n6, n8, n10, n12, n13, n14;
  wire [1:0] next_STATE;

  // 2-bit saturating counter
  always @(posedge clock) begin
    if (reset) begin
      STATE_reg[0] <= 2'b01;
      STATE_reg[1] <= 2'b01;
    end else if (enable) begin
      case ({STATE_reg[1], STATE_reg[0]})
        2'b00: if (taken_i) STATE_reg <= 2'b01; else STATE_reg <= 2'b00;
        2'b01: if (taken_i) STATE_reg <= 2'b11; else STATE_reg <= 2'b00;
        2'b10: if (taken_i) STATE_reg <= 2'b11; else STATE_reg <= 2'b01;
        2'b11: if (taken_i) STATE_reg <= 2'b11; else STATE_reg <= 2'b10;
      endcase
    end
  end

  // Calculate next state
  assign n5 = STATE_reg[0];
  assign n6 = n5;
  assign n8 = STATE_reg[1];
  assign n10 = enable;
  assign n12 = n10;
  assign n13 = prediction_o & taken_i;
  assign n14 = prediction_o | taken_i;

endmodule

module DLH_X1 (G, D, Q);
  input G, D;
  output Q;
  assign Q = G & D;
endmodule

module DFFR_X1 (D, CK, RN, Q, QN);
  input D, CK, RN;
  output Q, QN;
  assign Q = D & CK & ~RN;
  assign QN = ~Q;
endmodule

module MUX2_X1 (A, B, S, Z);
  input A, B, S;
  output Z;
  assign Z = S ? B : A;
endmodule

module NOR2_X1 (A1, A2, ZN);
  input A1, A2;
  output ZN;
  assign ZN = ~(A1 | A2);
endmodule

module NAND2_X1 (A1, A2, ZN);
  input A1, A2;
  output ZN;
  assign ZN = ~(A1 & A2);
endmodule

module OAI21_X1 (B1, B2, A, ZN);
  input B1, B2, A;
  output ZN;
  assign ZN = ~(B1 & B2) & A;
endmodule

module INV_X1 (A, ZN);
  input A;
  output ZN;
  assign ZN = ~A;
endmodule