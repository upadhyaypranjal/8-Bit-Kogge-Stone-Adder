###############################################################
# SDC File for Kogge-Stone Adder (180nm)
# Author : Pranjal
# Purpose: Timing constraints for synthesis in Cadence Genus
###############################################################

# -------------------------------------------------------------
# Define the top-level clock
# -------------------------------------------------------------
# Assuming 180nm design, typical frequency ~100–200 MHz
# (Adjust as per your requirement)
create_clock -name CLK -period 5.0 [get_ports clk]
# => 5 ns period = 200 MHz target frequency

# -------------------------------------------------------------
# Input and Output Delays
# -------------------------------------------------------------
# Input delay: time for signals to arrive after clock edge
# Output delay: time after clock edge before output is captured
# (Assuming small on-chip combinational path)
set_input_delay  0.5 -clock CLK [all_inputs]
set_output_delay 0.5 -clock CLK [all_outputs]

# -------------------------------------------------------------
# Input Drive Strength Assumptions
# -------------------------------------------------------------
# Model the input pins as driven by a strong buffer
# (Adjust drive cell as per your library)
set_driving_cell -lib_cell BUFX4 [all_inputs]

# -------------------------------------------------------------
# Output Load Assumptions
# -------------------------------------------------------------
# Assume outputs drive moderate load (fanout ~4)
set_load 0.1 [all_outputs]

# -------------------------------------------------------------
# Clock Uncertainty and Jitter
# -------------------------------------------------------------
# Add realistic clock uncertainty (setup/hold margin)
set_clock_uncertainty 0.2 [get_clocks CLK]

# -------------------------------------------------------------
# Design Rule Constraints (optional)
# -------------------------------------------------------------
# Limit transition and capacitance for better QoR
set_max_transition 0.5 [current_design]
set_max_capacitance 0.2 [current_design]
set_max_fanout 8 [current_design]

# -------------------------------------------------------------
# End of File
# -------------------------------------------------------------
