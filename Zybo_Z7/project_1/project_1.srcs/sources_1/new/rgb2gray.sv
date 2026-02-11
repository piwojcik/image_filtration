`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Piotr Wojcik 
// 
// Create Date: 02/06/2026 11:05:43 PM
// Design Name: 
// Module Name: rgb2gray
// Project Name: Image filtration
// Target Devices: 
// Tool Versions: 
// Description: Converts 24-bit RGB data to 8-bit grayscale before filtration
// 
// Dependencies: RGB to Grayscale Converter uses ITU-R BT.601 standard
// 
// revision:
// revision 0.01 - File Created
// Additional Comments: ITU-R BT.601 standard: Y = 0.299*R + 0.587*G + 0.114*B
//                      For simple hardware implementation used bit-shifting, and approximated coefficients:
//                      Y = 0.281*R + 0.562*G + 0.093*B
//////////////////////////////////////////////////////////////////////////////////


module rgb2gray(
    input  logic        clk,
    input  logic        rst,
    input  logic        hsync_in,
    input  logic        vsync_in,
    input  logic        vde_in,
    
    input  logic [23:0] rgb_in,
    
    output logic        hsync_o,
    output logic        vsync_o,
    output logic        vde_o,
    
    output logic [7:0] gray_o
);
    
    always_ff @(posedge clk) begin
      if(rst) begin
        hsync_o <= '0;
        vsync_o <= '0;
        vde_o   <= '0;                 
        gray_o  <= '0;
      end else begin
        hsync_o <= hsync_in;
        vsync_o <= vsync_in;
        vde_o   <= vde_in;                 
        gray_o  <= calc_gray;        
      end
    end

logic [7:0] r, g, b, r1, r2, g1, g2, b1, b2, calc_gray; 
   
//    coefficients r * 0,281 + g * 0,562 + b * 0,093
    always_comb begin
      r = rgb_in[23:16];
      g = rgb_in[15:8];
      b = rgb_in[7:0];

      r1 = r >> 2;
      r2 = r >> 5;

      g1 = g >> 1;
      g2 = g >> 4;
     
      b1 = b >> 4;
      b2 = b >> 5;   
      
      calc_gray = r1+r2+g1+g2+b1+b2;
    end
endmodule
