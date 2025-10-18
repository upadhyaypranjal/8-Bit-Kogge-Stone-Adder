###############################################################
# Cadence Genus Synthesis Script for Kogge-Stone Adder
###############################################################

# -------------------------------------------------------------
# Library setup
# -------------------------------------------------------------
set_db init_lib_search_path {/home/install/FOUNDRY/digital/90nm/dig/lib/}
set_db library slow.lib

# -------------------------------------------------------------
# Read and elaborate the design
# -------------------------------------------------------------
# Read RTL source file
read_hdl {./kogge_stone_adder.v}

# Elaborate top-level module
# (Change this if your top module name is different)
elaborate kogge_stone_adder

# -------------------------------------------------------------
# Read timing constraints
# -------------------------------------------------------------
read_sdc ./constraint_input.sdc

# -------------------------------------------------------------
# Synthesis effort settings
# -------------------------------------------------------------
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

# -------------------------------------------------------------
# Run synthesis flow
# -------------------------------------------------------------
syn_generic
syn_map
syn_opt

# -------------------------------------------------------------
# Write out the synthesized results
# -------------------------------------------------------------
write_hdl > kogge_stone_netlist.v
write_sdc > kogge_stone_output.sdc

# -------------------------------------------------------------
# Generate reports
# -------------------------------------------------------------
report timing > kogge_stone_timing.rpt
report power  > kogge_stone_power.rpt
report area   > kogge_stone_area.rpt
report gates  > kogge_stone_gates.rpt

# -------------------------------------------------------------
# Optional: Launch GUI for post-synthesis analysis
# -------------------------------------------------------------
gui_show
