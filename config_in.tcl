# --------------------------------------------------
# Design Information
# --------------------------------------------------
set ::env(DESIGN_NAME) aslss_soc_top

# RTL files
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/rtl/**/*.v]

# --------------------------------------------------
# Clock Configuration
# --------------------------------------------------
set ::env(CLOCK_PORT) clk
set ::env(CLOCK_PERIOD) 10.0

# --------------------------------------------------
# PDK / Library
# --------------------------------------------------
set ::env(PDK) sky130A
set ::env(STD_CELL_LIBRARY) sky130_fd_sc_hd

# --------------------------------------------------
# Constraints
# --------------------------------------------------
set ::env(BASE_SDC_FILE) $::env(DESIGN_DIR)/src/constrains/aslss_soc.sdc

# --------------------------------------------------
# Floorplan (CRITICAL FIX)
# --------------------------------------------------

# Higher utilization (important for small design)
set ::env(FP_CORE_UTIL) 45

# Square aspect ratio
set ::env(FP_ASPECT_RATIO) 1.0

# ✅ SMALL DIE (fix for placement failure)
set ::env(DIE_AREA) "0 0 200 200"

# ✅ CORE inside DIE
set ::env(CORE_AREA) "10 10 190 190"

# --------------------------------------------------
# PDN (SAFE SETTINGS)
# --------------------------------------------------

# Large enough pitch to avoid PDN-0175
set ::env(FP_PDN_VPITCH) 25
set ::env(FP_PDN_HPITCH) 25

# Reasonable strap width
set ::env(FP_PDN_VWIDTH) 3
set ::env(FP_PDN_HWIDTH) 3

# --------------------------------------------------
# Placement (CRITICAL FIX)
# --------------------------------------------------

# Higher density required for convergence
set ::env(PL_TARGET_DENSITY) 0.70

# --------------------------------------------------
# Synthesis
# --------------------------------------------------

set ::env(SYNTH_STRATEGY) "AREA 0"

# Updated (non-deprecated)
set ::env(MAX_FANOUT_CONSTRAINT) 6

# --------------------------------------------------
# Clock Tree
# --------------------------------------------------

set ::env(RUN_CTS) 1

# --------------------------------------------------
# Routing
# --------------------------------------------------

set ::env(RUN_ROUTING) 1

# (Optional stability improvement)
set ::env(GLB_RT_ADJUSTMENT) 0.30

# --------------------------------------------------
# Checks
# --------------------------------------------------

set ::env(RUN_DRC) 1
set ::env(RUN_LVS) 1
