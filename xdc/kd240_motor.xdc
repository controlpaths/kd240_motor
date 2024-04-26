
#------------------------------------------------------------------
# Bitstream properties
#------------------------------------------------------------------
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]

#----------------------------------------------------------------------------
# Pin Constraints
#----------------------------------------------------------------------------

## Gate Drive

set_property PACKAGE_PIN G9 [get_ports {gate_drive_en[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gate_drive_en[0]}]
set_property SLEW SLOW [get_ports {gate_drive_en[0]}]
set_property DRIVE 4 [get_ports {gate_drive_en[0]}]

set_property PACKAGE_PIN H10 [get_ports gate_drive_phase_a]
set_property IOSTANDARD LVCMOS33 [get_ports gate_drive_phase_a]
set_property SLEW SLOW [get_ports gate_drive_phase_a]
set_property DRIVE 4 [get_ports gate_drive_phase_a]

set_property PACKAGE_PIN H9 [get_ports gate_drive_phase_b]
set_property IOSTANDARD LVCMOS33 [get_ports gate_drive_phase_b]
set_property SLEW SLOW [get_ports gate_drive_phase_b]
set_property DRIVE 4 [get_ports gate_drive_phase_b]

set_property PACKAGE_PIN G10 [get_ports gate_drive_phase_c]
set_property IOSTANDARD LVCMOS33 [get_ports gate_drive_phase_c]
set_property SLEW SLOW [get_ports gate_drive_phase_c]
set_property DRIVE 4 [get_ports gate_drive_phase_c]


# 25Mhz clock
set_property PACKAGE_PIN L2 [get_ports CLK_IN_gem]
set_property IOSTANDARD LVCMOS18 [get_ports CLK_IN_gem]