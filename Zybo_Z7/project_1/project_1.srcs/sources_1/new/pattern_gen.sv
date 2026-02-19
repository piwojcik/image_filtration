`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Piotr Wojcik
// 
// Module Name: pattern_gen
// Project Name: Image filtration
// Target Devices: 
// Tool Versions: 
// Description: Module generates test patterns before filtration
// 
// Revision 0.01 - File Created
// Additional Comments: If disabled (sw3 - off), module outputs pixel_data from HDMI input
// 
//////////////////////////////////////////////////////////////////////////////////

module pattern_gen (
    input  logic       clk,
    input  logic       rst,
    input  logic       vde_i,
    input  logic       hsync_i,
    input  logic       vsync_i,
    input  logic       pattern_gen_en,
    input  logic [7:0] pixel_i,

    output logic [7:0] pixel_o,
    output logic       vde_o,
    output logic       hsync_o,
    output logic       vsync_o
);
    logic [7:0] pixel_gen, pixel_reg;
    logic [11:0] x_pos, y_pos;
    logic vde_prev, hsync_reg, vsync_reg;

    always_ff @(posedge clk) begin
        if(rst) begin
            vde_o <= 1'b0;
            hsync_o <= 1'b0;
            vsync_o <= 1'b0;
            pixel_o <= 8'b0;
            x_pos <= 0;
            y_pos <= 0;
        end 
        else begin
            vde_o <= vde_prev;
            hsync_o <= hsync_reg;
            vsync_o <= vsync_reg;
            vde_prev <= vde_i;
            hsync_reg <= hsync_i;         
            vsync_reg <= vsync_i;         
            pixel_o <= pixel_gen;
//            pixel_reg <= pixel_gen;
    
            if(vde_i) begin
                x_pos <= (x_pos == 1919) ? 0 : x_pos + 1;
            end
    
            if(hsync_i) begin 
                x_pos <= 0;
            end
    
            if(vsync_i) begin
                y_pos <= 0;
            end 
            else if(vde_prev && !vde_i) begin 
                y_pos <= (y_pos == 1079) ? 0 : y_pos + 1;
            end
        end
    end

    always_comb begin
        if(pattern_gen_en) begin

            if(x_pos < 640 & y_pos < 720) begin
                pixel_gen = y_pos[9:2]; 
            end 
            else if(x_pos < 1280 & y_pos < 720) begin
                pixel_gen = x_pos[10:3]; 
            end        
            else if(x_pos < 1920 & y_pos < 720) begin
                pixel_gen = ((x_pos >> 6) % 2 == (y_pos >> 6) % 2) ? 8'hFF : 8'h00; 
            end
            else begin
                pixel_gen = 8'h7F; 
            end
        end else begin
            pixel_gen = pixel_i;
        end
    end
endmodule