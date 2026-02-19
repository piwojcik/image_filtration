`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Piotr Wojcik
// 
// Create Date: 02/02/2026 06:38:19 PM
// Design Name: 
// Module Name: top
// Project Name: Image filtration
// Target Devices: 
// Tool Versions: 
// Description: Top module for filtration system
// 
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input  logic sys_clk_125mhz,
    input  logic sys_rst,

    inout  wire hdmi_rx_scl,
    inout  wire hdmi_rx_sda,
    input  logic hdmi_rx_clk_p,
    input  logic hdmi_rx_clk_n,
    input  logic [2:0] hdmi_rx_data_n,
    input  logic [2:0] hdmi_rx_data_p,
    output  logic hdmi_rx_hpd,

    output logic hdmi_tx_clk_p,
    output logic hdmi_tx_clk_n,
    output logic [2:0] hdmi_tx_data_n,
    output logic [2:0] hdmi_tx_data_p,

    output logic [3:0] led,
    input  logic [3:0] sw
);        

logic [23:0] rgb_data, data_reg;
logic [7:0] gray_data;
logic video_active_reg, hsync_reg, vsync_reg, PixelClk_o;
logic video_active_in, hsync_in, vsync_in;

assign hdmi_rx_hpd = 1'b1;
assign video_active_reg = led[0];
assign led[2] = sys_rst;

    
design_1_wrapper HDMI2HDMI(
    .TMDS_0_clk_n(hdmi_rx_clk_n),
    .TMDS_0_clk_p(hdmi_rx_clk_p),
    .TMDS_0_data_n(hdmi_rx_data_n),
    .TMDS_0_data_p(hdmi_rx_data_p),
    .TMDS_1_clk_n(hdmi_tx_clk_n),
    .TMDS_1_clk_p(hdmi_tx_clk_p),
    .TMDS_1_data_n(hdmi_tx_data_n),
    .TMDS_1_data_p(hdmi_tx_data_p),
    .hdmi_in_ddc_scl_io(hdmi_rx_scl),
    .hdmi_in_ddc_sda_io(hdmi_rx_sda),

    .pLocked_0(led[1]),
    .reset_rtl(sys_rst),
    .sys_clock(sys_clk_125mhz),
    .PixelClk(PixelClk_o),  
    // HDMI IN to RGB
    .dvi2RGB_active_video(video_active_in),
    .dvi2RGB_data(rgb_data),
    .dvi2RGB_hsync(hsync_in),
    .dvi2RGB_vsync(vsync_in),
    // RGB to HDMI OUT
    .RGB2dvi_active_video(video_active_reg),
    .RGB2dvi_data({filtered_pixel,filtered_pixel,filtered_pixel}),
    .RGB2dvi_hsync(hsync_reg),
    .RGB2dvi_vsync(vsync_reg)
    );
    
    rgb2gray u_rgb2gray( 
    .clk(PixelClk_o),
    .rst(sys_rst),
    .hsync_in(hsync_in),
    .vsync_in(vsync_in),
    .vde_in(video_active_in),
    
    .rgb_in(rgb_data),
    
    .hsync_o(hsync_gray_o),
    .vsync_o(vsync_gray_o),
    .vde_o(vde_gray_o),
    
    .gray_o(gray_data)
);

logic hsync_gray_o, vsync_gray_o, vde_gray_o;
logic [7:0] pattern_data;
logic hsync_pattern_o, vsync_pattern_o, vde_pattern_o;

pattern_gen u_pattern_gen(
    .clk(PixelClk_o),
    .rst(sys_rst),
    .hsync_i(hsync_gray_o),
    .vsync_i(vsync_gray_o),
    .vde_i(vde_gray_o),
    .pattern_gen_en(sw[3]),
    .pixel_i(gray_data),

    .hsync_o(hsync_pattern_o),
    .vsync_o(vsync_pattern_o),
    .vde_o(vde_pattern_o),

    .pixel_o(pattern_data)
);

logic [23:0] row0, row1, row2;

line_buffers_ctrl u_line_buffers_ctrl(
    .clk(PixelClk_o),
    .rst(sys_rst),
    .vde_i(vde_pattern_o),
    .hsync_i(hsync_pattern_o),
    .vsync_i(vsync_pattern_o),
    .gray_i(pattern_data),
    
    .row0(row0),
    .row1(row1),
    .row2(row2),
    
    .vde_o(video_active_linebuf), 
    .hsync_o(hsync_linebuf),
    .vsync_o(vsync_linebuf)
);
 logic video_active_linebuf, hsync_linebuf, vsync_linebuf;
 logic [7:0] filtered_pixel;

filtration_ctrl u_filtration_ctrl(
    .clk(PixelClk_o),
    .rst(sys_rst),
    .vde_i(video_active_linebuf),
    .hsync_i(hsync_linebuf),
    .vsync_i(vsync_linebuf),
    .filter_mode_i(sw),

    .row0(row0),
    .row1(row1),
    .row2(row2),

    .pixel_o(filtered_pixel), 
    .vde_o(video_active_reg), 
    .hsync_o(hsync_reg),
    .vsync_o(vsync_reg)
);
endmodule