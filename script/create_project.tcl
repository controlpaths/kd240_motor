## Script version:  1.0
## Author:  P.Trujillo (pablo@controlpaths.com)


set projectDir ../project
set projectName kd240_motor
set bdName kd240_motor_bd
set srdDir ../src
set xdcDir ../xdc
set memDir ../memory_content
set bdDir ./bd

## Create project in ../project
create_project -force $projectDir/$projectName.xpr

## Set verilog as default language
set_property target_language Verilog [current_project]

## Set current board eclypsez7.
set_property board_part xilinx.com:kd240_som:part0:1.0 [current_project]
set_property board_connections {som240_1_connector xilinx.com:kd240_carrier:som240_1_connector:1.0 som40_2_connector xilinx.com:kd240_carrier:som40_2_connector:1.0} [get_projects ../project/kd240_motor.xpr]

## Adding verilog files
add_file [glob $srdDir/*.v]

## Adding memory files
add_files [glob $memDir/cos.mem]
add_files [glob $memDir/sin.mem]

## Adding constraints files
# read_xdc $xdcDir/kd240_motor.xdc

## Create block design
create_bd_design $bdName

## Open vivado for verify
start_gui