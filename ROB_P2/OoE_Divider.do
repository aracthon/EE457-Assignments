
# OoE_Divider.do

#vlib work
# vlog +acc  "OoE_Divider.v"  # Do this manually
# vlog +acc  "OoE_Divider_tb.v" # Do this manually

vsim -novopt -t 1ps -lib work OoE_Divider_tb
do {OoE_Divider_wave.do}
view wave
view structure
view signals
log -r *
run 3us
WaveRestoreZoom {0 ps} {500 ns}
