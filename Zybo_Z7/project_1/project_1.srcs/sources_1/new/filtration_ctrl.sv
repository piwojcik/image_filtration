`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Piotr Wojcik
// 
// Module Name: filtration_ctrl
// Project Name: Image filtration
// Target Devices: 
// Tool Versions: 
// Description: Module controls filters inputs and outputs
// 
// Revision 0.01 - File Created
// Additional Comments: Gauss, Emboss, Laplacian, Sharpen filters are provided
// 
//////////////////////////////////////////////////////////////////////////////////

module filtration_ctrl (
    input  logic       clk,
    input  logic       rst,
    input  logic       vde_i,
    input  logic       hsync_i,
    input  logic       vsync_i,
    input  logic [2:0] filter_mode_i,

    input  logic [23:0] row0,
    input  logic [23:0] row1,
    input  logic [23:0] row2,

    output logic [7:0] pixel_o,
    output logic       vde_o,
    output logic       hsync_o,
    output logic       vsync_o
);

    logic [7:0] pixel_val, pixel_reg, gauss_pixel_val, gauss2_pixel_val, sobel_pixel_val, emboss_pixel_val, laplacian_pixel_val, sharpen_pixel_val; 
    logic [7:0] window [0:2][0:2];
    logic vde_reg, hsync_reg, vsync_reg, vde_reg2, hsync_reg2, vsync_reg2;

    always_ff @(posedge clk) begin
        if(rst) begin
            vde_o <= 1'b0;
            hsync_o <= 1'b0;
            vsync_o <= 1'b0;
            pixel_o <= 8'b0;
        end 
        else begin
             vde_o <= vde_reg2;
             hsync_o <= hsync_reg2;
             vsync_o <= vsync_reg2;
            pixel_o <= pixel_reg;
            pixel_reg <= pixel_val;
        end
    end

Gauss_filter u_gauss_filter (
    .clk(clk),
    .rst(rst),
    .vde_i(vde_i),
    .hsync_i(hsync_i),
    .vsync_i(vsync_i),
    .row0(row0),
    .row1(row1),
    .row2(row2),
    .pixel_o(gauss_pixel_val),
    .vde_o(),
    .hsync_o(),
    .vsync_o()
);

Gauss_filter u_gauss_filter2 (
    .clk(clk),
    .rst(rst),
    .vde_i(vde_i),
    .hsync_i(hsync_i),
    .vsync_i(vsync_i),
    .row0(row0),
    .row1(row1),
    .row2(row2),
    .pixel_o(gauss2_pixel_val),
    .vde_o(vde_reg2),
    .hsync_o(hsync_reg2),
    .vsync_o(vsync_reg2)
);

emboss_filter u_emboss_filter (
    .clk(clk),
    .rst(rst),
    .vde_i(vde_i),
    .hsync_i(hsync_i),
    .vsync_i(vsync_i),
    .row0(row0),
    .row1(row1),
    .row2(row2),
    .pixel_o(emboss_pixel_val),
    .vde_o(vde_reg),
    .hsync_o(hsync_reg),
    .vsync_o(vsync_reg)
);

Laplacian_filter u_laplacian_filter (
    .clk(clk),
    .rst(rst),
    .vde_i(vde_i),
    .hsync_i(hsync_i),
    .vsync_i(vsync_i),
    .row0(row0),
    .row1(row1),
    .row2(row2),
    .pixel_o(laplacian_pixel_val),
    .vde_o(),
    .hsync_o(),
    .vsync_o()
);

sharpen_filter u_sharpen_filter (
    .clk(clk),
    .rst(rst),
    .vde_i(vde_i),
    .hsync_i(hsync_i),
    .vsync_i(vsync_i),
    .row0(row0),
    .row1(row1),
    .row2(row2),
    .pixel_o(sharpen_pixel_val),
    .vde_o(),
    .hsync_o(),
    .vsync_o()
);
// Sobel_filter sobel_filter (
//     .clk(clk),
//     .rst(rst),
//     .vde_i(vde_i),
//     .hsync_i(hsync_i),
//     .vsync_i(vsync_i),
//     .row0(row0),
//     .row1(row1),
//     .row2(row2),
//     .pixel_o(sobel_pixel_val),
//     .vde_o(),
//     .hsync_o(),
//     .vsync_o()
// );

always_comb begin
    case (filter_mode_i)
        3'd0: pixel_val = row1[15:8]; 
        3'd1: pixel_val = gauss_pixel_val; 
        3'd2: pixel_val = gauss2_pixel_val;
        3'd3: pixel_val = emboss_pixel_val; 
        3'd4: pixel_val = laplacian_pixel_val;
        3'd5: pixel_val = sharpen_pixel_val;
        default: pixel_val = row1[15:8];
    endcase
end
endmodule