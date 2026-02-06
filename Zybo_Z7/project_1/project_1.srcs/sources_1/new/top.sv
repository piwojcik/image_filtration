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
    input  logic sys_rst_n,
    output  logic hdmi_rx_hpd,
    inout  wire hdmi_rx_scl,
    inout  wire hdmi_rx_sda,
    input  logic hdmi_rx_clk_p,
    input  logic hdmi_rx_clk_n,
    input  logic [2:0] hdmi_rx_data_n,
    input  logic [2:0] hdmi_rx_data_p,
    output logic hdmi_tx_clk_p,
    output logic hdmi_tx_clk_n,
    output logic [2:0] hdmi_tx_data_n,
    output logic [2:0] hdmi_tx_data_p,
    output logic led[3:0],
    input logic sw[2:0]
);        
logic [23:0] data_in, data_reg;
logic video_active_reg, hsync_reg, vsync_reg, PixelClk_o;
logic video_active_in, hsync_in, vsync_in;

assign hdmi_rx_hpd = 1'b1;

always_ff @(posedge PixelClk_o) begin
    hsync_reg <= hsync_in;
    vsync_reg <= vsync_in;
    video_active_reg <= video_active_in;
    if(sw[1])begin
        data_reg  <= 24'hFFFFFF;
    end else begin
        data_reg <= data_in;
    end
end
    
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
    .reset_rtl(sw[0]),
    .sys_clock(sys_clk_125mhz),
    .PixelClk(PixelClk_o),  
    .RGB2dvi_active_video(video_active_in),
    .RGB2dvi_data(data_in),
    .RGB2dvi_hsync(hync_in),
    .RGB2dvi_vsync(vsync_in),
    .dvi2RGB_active_video(video_active_in),
    .dvi2RGB_data(data_in),
    .dvi2RGB_hsync(hsync_in),
    .dvi2RGB_vsync(vsync_in)
    );
    
endmodule