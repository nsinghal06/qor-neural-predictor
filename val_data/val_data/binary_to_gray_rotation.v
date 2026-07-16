//726
module binary_to_gray_rotation (
  input [4:0] binary,
  input dir,
  output [4:0] gray,
  output [4:0] rotated
);

  wire [4:0] gray_pipe1;
  wire [4:0] gray_pipe2;
  wire [4:0] gray_pipe3;
  wire [4:0] gray_pipe4;
  wire [4:0] gray_pipe5;
  wire [4:0] gray_pipe6;
  wire [4:0] gray_pipe7;
  wire [4:0] gray_pipe8;
  wire [4:0] gray_pipe9;
  wire [4:0] gray_pipe10;
  
  wire [4:0] rotated_pipe1;
  wire [4:0] rotated_pipe2;
  wire [4:0] rotated_pipe3;
  wire [4:0] rotated_pipe4;
  wire [4:0] rotated_pipe5;
  wire [4:0] rotated_pipe6;
  wire [4:0] rotated_pipe7;
  wire [4:0] rotated_pipe8;
  wire [4:0] rotated_pipe9;
  wire [4:0] rotated_pipe10;
  
  assign gray_pipe1 = binary ^ {1'b0, binary[4:1]};
  assign gray_pipe2 = gray_pipe1 ^ {1'b0, gray_pipe1[4:1]};
  assign gray_pipe3 = gray_pipe2 ^ {1'b0, gray_pipe2[4:1]};
  assign gray_pipe4 = gray_pipe3 ^ {1'b0, gray_pipe3[4:1]};
  assign gray_pipe5 = gray_pipe4 ^ {1'b0, gray_pipe4[4:1]};
  assign gray_pipe6 = gray_pipe5 ^ {1'b0, gray_pipe5[4:1]};
  assign gray_pipe7 = gray_pipe6 ^ {1'b0, gray_pipe6[4:1]};
  assign gray_pipe8 = gray_pipe7 ^ {1'b0, gray_pipe7[4:1]};
  assign gray_pipe9 = gray_pipe8 ^ {1'b0, gray_pipe8[4:1]};
  assign gray_pipe10 = gray_pipe9 ^ {1'b0, gray_pipe9[4:1]};
  
  assign rotated_pipe1 = (dir) ? {gray_pipe10[4:1], gray_pipe10[0]} : {gray_pipe10[0], gray_pipe10[4:1]};
  assign rotated_pipe2 = (dir) ? {rotated_pipe1[4:1], rotated_pipe1[0]} : {rotated_pipe1[0], rotated_pipe1[4:1]};
  assign rotated_pipe3 = (dir) ? {rotated_pipe2[4:1], rotated_pipe2[0]} : {rotated_pipe2[0], rotated_pipe2[4:1]};
  assign rotated_pipe4 = (dir) ? {rotated_pipe3[4:1], rotated_pipe3[0]} : {rotated_pipe3[0], rotated_pipe3[4:1]};
  assign rotated_pipe5 = (dir) ? {rotated_pipe4[4:1], rotated_pipe4[0]} : {rotated_pipe4[0], rotated_pipe4[4:1]};
  assign rotated_pipe6 = (dir) ? {rotated_pipe5[4:1], rotated_pipe5[0]} : {rotated_pipe5[0], rotated_pipe5[4:1]};
  assign rotated_pipe7 = (dir) ? {rotated_pipe6[4:1], rotated_pipe6[0]} : {rotated_pipe6[0], rotated_pipe6[4:1]};
  assign rotated_pipe8 = (dir) ? {rotated_pipe7[4:1], rotated_pipe7[0]} : {rotated_pipe7[0], rotated_pipe7[4:1]};
  assign rotated_pipe9 = (dir) ? {rotated_pipe8[4:1], rotated_pipe8[0]} : {rotated_pipe8[0], rotated_pipe8[4:1]};
  assign rotated_pipe10 = (dir) ? {rotated_pipe9[4:1], rotated_pipe9[0]} : {rotated_pipe9[0], rotated_pipe9[4:1]};
  
  assign gray = gray_pipe10;
  assign rotated = rotated_pipe10;
  
endmodule