
# min_max_finder_part1.do

vlib work
vlog +acc  "min_max_finder_part1.v"
vlog +acc  "min_max_finder_part1_tb.v"
# vsim  work.min_max_finder_part1_tb
vsim -novopt -t 1ps -lib work min_max_finder_part1_tb
do {min_max_finder_part1_wave.do}
view wave
view structure
view signals
log -r *
run 3500ns
WaveRestoreZoom {0 ps} {500 ns}
