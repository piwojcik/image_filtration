//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
//Date        : Mon Feb  2 18:29:03 2026
//Host        : cadence62 running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (TMDS_0_clk_n,
    TMDS_0_clk_p,
    TMDS_0_data_n,
    TMDS_0_data_p,
    TMDS_1_clk_n,
    TMDS_1_clk_p,
    TMDS_1_data_n,
    TMDS_1_data_p,
    hdmi_in_ddc_scl_io,
    hdmi_in_ddc_sda_io,
    pLocked_0,
    reset_rtl,
    sys_clock);
  input TMDS_0_clk_n;
  input TMDS_0_clk_p;
  input [2:0]TMDS_0_data_n;
  input [2:0]TMDS_0_data_p;
  output TMDS_1_clk_n;
  output TMDS_1_clk_p;
  output [2:0]TMDS_1_data_n;
  output [2:0]TMDS_1_data_p;
  inout hdmi_in_ddc_scl_io;
  inout hdmi_in_ddc_sda_io;
  output pLocked_0;
  input reset_rtl;
  input sys_clock;

  wire TMDS_0_clk_n;
  wire TMDS_0_clk_p;
  wire [2:0]TMDS_0_data_n;
  wire [2:0]TMDS_0_data_p;
  wire TMDS_1_clk_n;
  wire TMDS_1_clk_p;
  wire [2:0]TMDS_1_data_n;
  wire [2:0]TMDS_1_data_p;
  wire aPixelClkLckd_0;
  wire hdmi_in_ddc_scl_i;
  wire hdmi_in_ddc_scl_io;
  wire hdmi_in_ddc_scl_o;
  wire hdmi_in_ddc_scl_t;
  wire hdmi_in_ddc_sda_i;
  wire hdmi_in_ddc_sda_io;
  wire hdmi_in_ddc_sda_o;
  wire hdmi_in_ddc_sda_t;
  wire pLocked_0;
  wire reset_rtl;
  wire sys_clock;

  design_1 design_1_i
       (.TMDS_0_clk_n(TMDS_0_clk_n),
        .TMDS_0_clk_p(TMDS_0_clk_p),
        .TMDS_0_data_n(TMDS_0_data_n),
        .TMDS_0_data_p(TMDS_0_data_p),
        .TMDS_1_clk_n(TMDS_1_clk_n),
        .TMDS_1_clk_p(TMDS_1_clk_p),
        .TMDS_1_data_n(TMDS_1_data_n),
        .TMDS_1_data_p(TMDS_1_data_p),
        .hdmi_in_ddc_scl_i(hdmi_in_ddc_scl_i),
        .hdmi_in_ddc_scl_o(hdmi_in_ddc_scl_o),
        .hdmi_in_ddc_scl_t(hdmi_in_ddc_scl_t),
        .hdmi_in_ddc_sda_i(hdmi_in_ddc_sda_i),
        .hdmi_in_ddc_sda_o(hdmi_in_ddc_sda_o),
        .hdmi_in_ddc_sda_t(hdmi_in_ddc_sda_t),
        .pLocked_0(pLocked_0),
        .reset_rtl(reset_rtl),
        .sys_clock(sys_clock));
  IOBUF hdmi_in_ddc_scl_iobuf
       (.I(hdmi_in_ddc_scl_o),
        .IO(hdmi_in_ddc_scl_io),
        .O(hdmi_in_ddc_scl_i),
        .T(hdmi_in_ddc_scl_t));
  IOBUF hdmi_in_ddc_sda_iobuf
       (.I(hdmi_in_ddc_sda_o),
        .IO(hdmi_in_ddc_sda_io),
        .O(hdmi_in_ddc_sda_i),
        .T(hdmi_in_ddc_sda_t));
endmodule
