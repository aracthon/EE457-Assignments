
# merge_sort_P4.do

vlib work
vlog +acc  "merge_sort_P4.v"
vlog +acc  "merge_sort_P4_tb.v"
# vsim  work.merge_sort_P4_tb
vsim -novopt -t 1ps -lib work merge_sort_P4_tb
do {merge_sort_P4_wave.do}
view wave
view structure
view signals
log -r *
run 5500ns
WaveRestoreZoom {0 ns} {1250 ns}