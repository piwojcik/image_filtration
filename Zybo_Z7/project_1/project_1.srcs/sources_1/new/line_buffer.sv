`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Piotr Wojcik 
// 
// Create Date: 02/11/2026 
// Design Name: 
// Module Name: line_buffer
// Project Name: Image filtration
// Target Devices: 
// Tool Versions: 
// Description: Single line buffer for storing 1920 pixels
// 
// Dependencies: 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module line_buffer #(
    parameter int LINE_WIDTH = 1920,
    parameter int DATA_WIDTH = 8
)(
    input  logic                   clk,
    input  logic                   rst,
    input  logic                   vde_i,    
    input  logic [DATA_WIDTH-1:0]  din,     
    output logic [DATA_WIDTH-1:0]  dout     
);

    logic [$clog2(LINE_WIDTH)-1:0] addr;
    logic [DATA_WIDTH-1:0] mem [0:LINE_WIDTH-1];

    always_ff @(posedge clk) begin
        if (rst) begin
            addr <= '0;
        end else if (vde_i) begin
            dout <= mem[addr];
            mem[addr] <= din;
            if (addr == LINE_WIDTH - 1)
                addr <= '0;
            else
                addr <= addr + 1;
        end else begin
            addr <= '0;
        end
    end

endmodule