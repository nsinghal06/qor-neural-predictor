//809
module rotator_encoder (
    input clk,
    input load,
    input [1:0] ena,
    input [7:0] in,
    input [99:0] data,
    output reg [7:0] out
);

    reg [99:0] shifted_data;
    wire [7:0] priority_encoder_out;
    
    // Priority Encoder
    assign priority_encoder_out = (in[7]) ? 7'b111 : 
                                 (in[6]) ? 7'b110 : 
                                 (in[5]) ? 7'b101 : 
                                 (in[4]) ? 7'b100 : 
                                 (in[3]) ? 7'b011 : 
                                 (in[2]) ? 7'b010 : 
                                 (in[1]) ? 7'b001 : 
                                 (in[0]) ? 7'b000 : 7'b000;
    
    // Barrel Shifter
    always @(posedge clk) begin
        if (load) begin
            shifted_data <= data;
        end else begin
            case (ena)
                2'b00: shifted_data <= {shifted_data[98:0], shifted_data[99]};
                2'b01: shifted_data <= {shifted_data[97:0], shifted_data[99:98]};
                2'b10: shifted_data <= {shifted_data[99], shifted_data[98:0]};
                2'b11: shifted_data <= shifted_data;
            endcase
        end
    end
    
    // Output
    always @(posedge clk) begin
        if (load) begin
            out <= in;
        end else begin
            out <= shifted_data[99-priority_encoder_out -: 8] | (in << priority_encoder_out);
        end
    end
    
endmodule