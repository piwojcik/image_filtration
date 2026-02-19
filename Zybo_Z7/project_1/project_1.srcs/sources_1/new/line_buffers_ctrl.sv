`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Piotr Wojcik 
// 
// Create Date: 02/11/2026
// Design Name: 
// Module Name: line_buffers_ctrl
// Project Name: Image filtration
// Target Devices: 
// Tool Versions: 
// Description: Controler of line buffers outputs 3 rows - each 3 pixels for window3x3
// 
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module line_buffers_ctrl #(
    parameter int LINE_WIDTH = 1920
)(
    input  logic       clk,
    input  logic       rst,
    input  logic       vde_i,
    input  logic       hsync_i,
    input  logic       vsync_i,
    input  logic [7:0] gray_i,

    output logic [23:0] row0,
    output logic [23:0] row1,
    output logic [23:0] row2,

    output logic       vde_o,
    output logic       hsync_o,
    output logic       vsync_o
);

    logic [7:0] line_1_pxl_o, line_2_pxl_o;
    logic [7:0] p11, p12, p13;
    logic [7:0] p21, p22, p23;
    logic [7:0] p31, p32, p33;
    
     assign row0 = {p11, p12, p13};
     assign row1 = {p21, p22, p23};
     assign row2 = {p31, p32, p33};

    line_buffer #(.LINE_WIDTH(LINE_WIDTH)) line_buffer_1 (
        .clk(clk),
        .rst(rst),
        .vde_i(vde_i),
        .din(gray_i),
        .dout(line_1_pxl_o)
    );

    line_buffer #(.LINE_WIDTH(LINE_WIDTH)) line_buffer_2 (
        .clk(clk),
        .rst(rst),
        .vde_i(vde_i),
        .din(line_1_pxl_o),
        .dout(line_2_pxl_o)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            {p11, p12, p13} <= '0;
            {p21, p22, p23} <= '0;
            {p31, p32, p33} <= '0;
            vde_o <= '0;
            hsync_o <= '0;
            vsync_o <= '0;
        end else if (vde_i) begin
            p11 <= p12; p12 <= p13; p13 <= line_2_pxl_o;
            p21 <= p22; p22 <= p23; p23 <= line_1_pxl_o;
            p31 <= p32; p32 <= p33; p33 <= gray_i;

            vde_o   <= vde_i;
            hsync_o <= hsync_i;
            vsync_o <= vsync_i;
        end else begin
            vde_o   <= vde_i;
            hsync_o <= hsync_i;
            vsync_o <= vsync_i;
        end
    end

endmodule