`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Piotr Wojcik
// 
// Module Name: Sharpen_filter
// Project Name: Image filtration
// Target Devices: 
// Tool Versions: 
// Description: Module implements sharpening filter 
// 
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sharpen_filter (
    input  logic       clk,
    input  logic       rst,
    input  logic       vde_i,
    input  logic       hsync_i,
    input  logic       vsync_i,

    input  logic [23:0] row0,
    input  logic [23:0] row1,
    input  logic [23:0] row2,

    output logic [7:0] pixel_o,
    output logic       vde_o,
    output logic       hsync_o,
    output logic       vsync_o
);
    logic signed [17:0] conv_result;
    logic [7:0] pixel_val; 
    logic [7:0] window [0:2][0:2];
//    logic vde_reg, hsync_reg, vsync_reg, vde_reg2, hsync_reg2, vsync_reg2;

    always_ff @(posedge clk) begin
        if(rst) begin
            vde_o <= 1'b0;
            hsync_o <= 1'b0;
            vsync_o <= 1'b0;
            pixel_o <= 8'b0;
        end 
        else begin
            vde_o <= vde_i;
            hsync_o <= hsync_i;
            vsync_o <= vsync_i;
            pixel_o <= pixel_val;
        end
    end

    localparam logic signed [7:0] SHARPEN_KERNEL [0:2][0:2] = '{
        '{0, -1, 0},
        '{-1, 5, -1}, 
        '{0, -1, 0}
    };


     always_comb begin
       window[0][0] = row0[23:16]; window[0][1] = row0[15:8]; window[0][2] = row0[7:0];
       window[1][0] = row1[23:16]; window[1][1] = row1[15:8]; window[1][2] = row1[7:0];
       window[2][0] = row2[23:16]; window[2][1] = row2[15:8]; window[2][2] = row2[7:0];
       pixel_val = 0;
       conv_result = 0;

        for(int i = 0; i < 3; i++) begin
            for(int j = 0; j < 3; j++) begin
                conv_result += $signed({1'b0, window[i][j]}) * SHARPEN_KERNEL[i][j];
            end
        end
          
         if(conv_result <= 16'sd0)begin
           conv_result = 16'sd0;
         end else if(conv_result >= 16'sd255)begin
           conv_result = 16'sd255;
         end 
 
        pixel_val = conv_result[7:0];
     end

endmodule