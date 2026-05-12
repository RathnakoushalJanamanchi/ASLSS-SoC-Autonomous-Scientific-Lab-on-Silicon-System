# ------------------------------------
# Clock Definition
# ------------------------------------

create_clock -name core_clk -period 10 [get_ports clk]

# 10ns clock → 100 MHz


# ------------------------------------
# Input Delays
# ------------------------------------

set_input_delay 2 -clock core_clk [all_inputs]


# ------------------------------------
# Output Delays
# ------------------------------------

set_output_delay 2 -clock core_clk [all_outputs]


# ------------------------------------
# False Paths
# ------------------------------------

set_false_path -from [get_ports rst]


# ------------------------------------
# Clock Uncertainty
# ------------------------------------

set_clock_uncertainty 0.1 [get_clocks core_clk]


# ------------------------------------
# Driving Cell
# ------------------------------------

set_driving_cell -lib_cell sky130_fd_sc_hd__inv_1 [all_inputs]


# ------------------------------------
# Load
# ------------------------------------

set_load 0.05 [all_outputs]
