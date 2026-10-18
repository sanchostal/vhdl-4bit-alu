## 100 MHz Clock on Basys 3 (Pin W5)
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Active-Low Reset -> Switch SW15 (Far-left switch: UP = Run, DOWN = Reset)
set_property -dict { PACKAGE_PIN R2   IOSTANDARD LVCMOS33 } [get_ports rst_n]

## Input A[3:0] -> Switches SW0 to SW3
set_property -dict { PACKAGE_PIN V17  IOSTANDARD LVCMOS33 } [get_ports {A[0]}]
set_property -dict { PACKAGE_PIN V16  IOSTANDARD LVCMOS33 } [get_ports {A[1]}]
set_property -dict { PACKAGE_PIN W16  IOSTANDARD LVCMOS33 } [get_ports {A[2]}]
set_property -dict { PACKAGE_PIN W17  IOSTANDARD LVCMOS33 } [get_ports {A[3]}]

## Input B[3:0] -> Switches SW4 to SW7
set_property -dict { PACKAGE_PIN W15  IOSTANDARD LVCMOS33 } [get_ports {B[0]}]
set_property -dict { PACKAGE_PIN V15  IOSTANDARD LVCMOS33 } [get_ports {B[1]}]
set_property -dict { PACKAGE_PIN W14  IOSTANDARD LVCMOS33 } [get_ports {B[2]}]
set_property -dict { PACKAGE_PIN W13  IOSTANDARD LVCMOS33 } [get_ports {B[3]}]

## Opcode[2:0] -> Switches SW8 to SW10
set_property -dict { PACKAGE_PIN V2   IOSTANDARD LVCMOS33 } [get_ports {opcode[0]}]
set_property -dict { PACKAGE_PIN T3   IOSTANDARD LVCMOS33 } [get_ports {opcode[1]}]
set_property -dict { PACKAGE_PIN T2   IOSTANDARD LVCMOS33 } [get_ports {opcode[2]}]

## Output result[3:0] -> LEDs LD0 to LD3
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33 } [get_ports {result[0]}]
set_property -dict { PACKAGE_PIN E19  IOSTANDARD LVCMOS33 } [get_ports {result[1]}]
set_property -dict { PACKAGE_PIN U19  IOSTANDARD LVCMOS33 } [get_ports {result[2]}]
set_property -dict { PACKAGE_PIN V19  IOSTANDARD LVCMOS33 } [get_ports {result[3]}]

## Flags -> LD4 (Carry-Out) and LD5 (Zero Flag)
set_property -dict { PACKAGE_PIN W18  IOSTANDARD LVCMOS33 } [get_ports carry_o]
set_property -dict { PACKAGE_PIN U15  IOSTANDARD LVCMOS33 } [get_ports zero_o]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
