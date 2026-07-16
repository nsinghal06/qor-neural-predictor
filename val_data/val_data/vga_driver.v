//1248
module vga_driver
    (
        CLOCK_PIXEL,
        RESET,
        PIXEL,
        PIXEL_H,
        PIXEL_V,
        VGA_RED,
        VGA_GREEN,
        VGA_BLUE,
        VGA_HS,
        VGA_VS
    );
    input CLOCK_PIXEL;
    input RESET;
    input [2:0] PIXEL; output [10:0] PIXEL_H;
    output [10:0] PIXEL_V;
    output VGA_RED;
    output VGA_GREEN;
    output VGA_BLUE;
    output VGA_HS;
    output VGA_VS;

    
    reg [10:0] hor_reg; reg [10:0] hor_pixel; reg hor_sync;
    wire hor_max = (hor_reg == 975); 
    reg [9:0] ver_reg; reg [10:0] ver_pixel; reg ver_sync;
    reg red, green, blue;
    wire ver_max = (ver_reg == 527); always @ (posedge CLOCK_PIXEL or posedge RESET) begin

        if (RESET) begin 
            hor_reg <= 0;
            ver_reg <= 0;
        end
        else if (hor_max) begin
            hor_reg <= 0;

            if (ver_max) begin
                ver_reg <= 0;
            end else begin
                ver_reg <= ver_reg + 1'b1;
            end
        end else begin
            hor_reg <= hor_reg + 1'b1;
        end

    end
    
    always @ (posedge CLOCK_PIXEL or posedge RESET) begin
    
        if (RESET) begin 
            hor_sync <= 0;
            ver_sync <= 0;
            
            red <= 0;
            green <= 0;
            blue <= 0;
            
            hor_pixel <= 0;
            ver_pixel <= 0;
        end
        else begin

            if (hor_reg == 840) begin          hor_sync <= 1;                 end else if (hor_reg == 928) begin hor_sync <= 0;                 end
            
            if (ver_reg == 493) begin          ver_sync <= 1;                 end else if (ver_reg == 496) begin ver_sync <= 0;                 end
                
            if (ver_reg > 480 || hor_reg > 800) begin
                red <= 0;
                green <= 0;
                blue <= 0;
                
                if (ver_reg > 480) begin
                    ver_pixel <= 0;
                end 
                if (hor_reg > 800) begin
                    hor_pixel <= 0;
                end 
                
            end
            
            else begin
                hor_pixel <= hor_reg;
                ver_pixel <= ver_reg;
                
                
                red   <= PIXEL[2];
                green <= PIXEL[1];
                blue  <= PIXEL[0];
                

            end
        end
    end

    assign VGA_HS = hor_sync;
    assign VGA_VS = ver_sync;
 
    assign VGA_RED =  red;
    assign VGA_GREEN = green;
    assign VGA_BLUE = blue;
    
    assign PIXEL_H = hor_pixel;
    assign PIXEL_V = ver_pixel;
    
endmodule