
# merge_sort_P2.do

vlib work
vlog +acc  "merge_sort_P2.v"
vlog +acc  "merge_sort_P2_tb.v"
# vsim  work.merge_sort_P2_tb
vsim -novopt -t 1ps -lib work merge_sort_P2_tb
do {merge_sort_P2_wave.do}
view wave
view structure
view signals
log -r *
run 1000ns
WaveRestoreZoom {0 ns} {750 ns}