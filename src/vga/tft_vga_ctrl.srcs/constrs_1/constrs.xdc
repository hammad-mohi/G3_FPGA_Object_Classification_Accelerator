##VGA
set_property -dict { PACKAGE_PIN D8 IOSTANDARD LVCMOS33 } [get_ports {vga_blue[3]}]
set_property -dict { PACKAGE_PIN D7 IOSTANDARD LVCMOS33 } [get_ports {vga_blue[2]}]
set_property -dict { PACKAGE_PIN C7 IOSTANDARD LVCMOS33 } [get_ports {vga_blue[1]}]
set_property -dict { PACKAGE_PIN B7 IOSTANDARD LVCMOS33 } [get_ports {vga_blue[0]}]

set_property -dict { PACKAGE_PIN A4 IOSTANDARD LVCMOS33 } [get_ports {vga_red[3]}]
set_property -dict { PACKAGE_PIN C5 IOSTANDARD LVCMOS33 } [get_ports {vga_red[2]}]
set_property -dict { PACKAGE_PIN B4 IOSTANDARD LVCMOS33 } [get_ports {vga_red[1]}]
set_property -dict { PACKAGE_PIN A3 IOSTANDARD LVCMOS33 } [get_ports {vga_red[0]}]

set_property -dict { PACKAGE_PIN A6 IOSTANDARD LVCMOS33 } [get_ports {vga_green[3]}]
set_property -dict { PACKAGE_PIN B6 IOSTANDARD LVCMOS33 } [get_ports {vga_green[2]}]
set_property -dict { PACKAGE_PIN A5 IOSTANDARD LVCMOS33 } [get_ports {vga_green[1]}]
set_property -dict { PACKAGE_PIN C6 IOSTANDARD LVCMOS33 } [get_ports {vga_green[0]}]

set_property -dict { PACKAGE_PIN B11 IOSTANDARD LVCMOS33 } [get_ports {tft_hsync_0}]
set_property -dict { PACKAGE_PIN B12 IOSTANDARD LVCMOS33 } [get_ports {tft_vsync_0}]


#CPU Reset
set_property -dict { PACKAGE_PIN C12 IOSTANDARD LVCMOS33 } [get_ports { reset }]; #IO_L7N_T1_D10_14 Sch=sw[5]

##Switches
#set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports { reset }]; #IO_L7N_T1_D10_14 Sch=sw[5]
#set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports { reset_rtl }]; #IO_L17N_T2_A13_D29_14 Sch=sw[6]

#Ethernet
set_property -dict { PACKAGE_PIN D5    IOSTANDARD LVCMOS33 } [get_ports { eth_ref_clk }]; # Sch=eth_ref_clk 
set_property IOB FALSE [get_cells {tft_vga_ctrl_i/axi_ethernetlite_0/U0/IOFFS_GEN2.RER_FF}]
set_property IOB FALSE [get_cells {tft_vga_ctrl_i/axi_ethernetlite_0/U0/IOFFS_GEN2.DVD_FF}]
set_property IOB FALSE [get_cells {tft_vga_ctrl_i/axi_ethernetlite_0/U0/IOFFS_GEN2.TEN_FF}]
set_property IOB FALSE [get_cells {tft_vga_ctrl_i/axi_ethernetlite_0/U0/IOFFS_GEN[0].RX_FF_I}]
set_property IOB FALSE [get_cells {tft_vga_ctrl_i/axi_ethernetlite_0/U0/IOFFS_GEN[0].TX_FF_I}]
set_property IOB FALSE [get_cells {tft_vga_ctrl_i/axi_ethernetlite_0/U0/IOFFS_GEN[1].RX_FF_I}]
set_property IOB FALSE [get_cells {tft_vga_ctrl_i/axi_ethernetlite_0/U0/IOFFS_GEN[1].TX_FF_I}]
set_property IOB FALSE [get_cells {tft_vga_ctrl_i/axi_ethernetlite_0/U0/IOFFS_GEN[2].RX_FF_I}]
set_property IOB FALSE [get_cells {tft_vga_ctrl_i/axi_ethernetlite_0/U0/IOFFS_GEN[2].TX_FF_I}]
set_property IOB FALSE [get_cells {tft_vga_ctrl_i/axi_ethernetlite_0/U0/IOFFS_GEN[3].RX_FF_I}]
set_property IOB FALSE [get_cells {tft_vga_ctrl_i/axi_ethernetlite_0/U0/IOFFS_GEN[3].TX_FF_I}]