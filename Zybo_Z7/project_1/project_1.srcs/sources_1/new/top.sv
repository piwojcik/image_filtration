`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2026 06:38:19 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
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

    output logic led[3:0],
    input logic sw[2:0]
);        

logic [23:0] rgb_data, data_reg;
logic [7:0] gray_data;
logic video_active_reg, hsync_reg, vsync_reg, PixelClk_o;
logic video_active_in, hsync_in, vsync_in;

assign hdmi_rx_hpd = 1'b1;

// always_ff @(posedge PixelClk_o) begin
//     hsync_reg <= hsync_in;
//     vsync_reg <= vsync_in;
//     video_active_reg <= video_active_in;
//     if(sw[1])begin
//         data_reg  <= 24'hFFFFFF;
//     end else begin
//         data_reg <= rgb_data;
//     end
// end
    
design_1_wrapper u_design_1_wrapper(
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
    .RGB2dvi_data({gray_data,gray_data,gray_data}),
    .RGB2dvi_hsync(hsync_reg),
    .RGB2dvi_vsync(vsync_reg)
    );
    
assign video_active_reg = led[0];
assign led[2] = sys_rst;

    rgb2gray u_rgb2gray( 
    .clk(PixelClk_o),
    .rst(sys_rst),
    .hsync_in(hsync_in),
    .vsync_in(vsync_in),
    .vde_in(video_active_in),
    
    .rgb_in(rgb_data),
    
    .hsync_o(hsync_reg),
    .vsync_o(vsync_reg),
    .vde_o(video_active_reg),
    
    .gray_o(gray_data)
);
endmodule