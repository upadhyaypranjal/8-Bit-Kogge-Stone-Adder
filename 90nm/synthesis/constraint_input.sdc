###############################################################
# constraint_input.sdc for Kogge-Stone Adder
# File: kogge_stone_adder.sdc
###############################################################

# Set units
set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA

###############################################################
# Create a virtual clock for combinational design
# Period: 10ns (100 MHz target)
###############################################################
create_clock -name vclk -period 10.0

###############################################################
# Input Constraints
###############################################################
# Set input delay (2 ns from virtual clock)
set_input_delay -clock vclk -max 2.0 [get_ports operand_a_i*]
set_input_delay -clock vclk -max 2.0 [get_ports operand_b_i*]

# Set minimum input delay for hold analysis
set_input_delay -clock vclk -min 0.5 [get_ports operand_a_i*]
set_input_delay -clock vclk -min 0.5 [get_ports operand_b_i*]

###############################################################
# Output Constraints
###############################################################
# Set output delay (2 ns before next clock edge)
set_output_delay -clock vclk -max 2.0 [get_ports result_o*]
set_output_delay -clock vclk -max 2.0 [get_ports overflow_o]

# Set minimum output delay for hold analysis
set_output_delay -clock vclk -min 0.5 [get_ports result_o*]
set_output_delay -clock vclk -min 0.5 [get_ports overflow_o]

###############################################################
# Drive Strength and Load
###############################################################
# Define drive strength for inputs (in library units)
set_drive 1.0 [get_ports operand_a_i*]
set_drive 1.0 [get_ports operand_b_i*]

# Define load capacitance for outputs (in pF)
set_load 0.1 [get_ports result_o*]
set_load 0.1 [get_ports overflow_o]

###############################################################
# Input Transition Time (Slew Rate)
###############################################################
set_input_transition 0.2 [get_ports operand_a_i*]
set_input_transition 0.2 [get_ports operand_b_i*]

###############################################################
# Design Rules
###############################################################
# Maximum fanout constraint
set_max_fanout 20 [current_design]

# Maximum transition time
set_max_transition 1.0 [current_design]

# Maximum capacitance
set_max_capacitance 0.5 [current_design]

###############################################################
# Operating Conditions
# Note: Adjust library name based on your actual library
###############################################################
# set_operating_conditions -library <your_library_name> -analysis_type on_chip_variation

###############################################################
# Environment Settings
###############################################################
# set_wire_load_model -name <wire_load_model> [current_design]
# set_wire_load_mode enclosed

###############################################################
# Path Groups (Optional - for better timing reports)
###############################################################
group_path -name INPUTS -from [all_inputs]
group_path -name OUTPUTS -to [all_outputs]
group_path -name COMBO -from [all_inputs] -to [all_outputs]

###############################################################
# End of constraint file
###############################################################
