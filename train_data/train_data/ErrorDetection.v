module ErrorDetection (
  input A_MSB,
  input B_MSB,
  input Operation,
  input S_MSB,
  output Error
  );
  
  assign Error = (A_MSB == B_MSB) && (A_MSB != S_MSB) && (Operation == 0);
  
endmodule