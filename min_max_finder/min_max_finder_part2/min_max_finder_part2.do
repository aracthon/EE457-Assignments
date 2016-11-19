
# min_max_finder_part2.do

vlib work
vlog +acc  "min_max_finder_part2.v"
vlog +acc  "min_max_finder_part2_tb.v"
# vsim  work.min_max_finder_part2_tb
vsim -novopt -t 1ps -lib work min_max_finder_part2_tb
do {min_max_finder_part2_wave.do}
view wave
view structure
view signals
log -r *
run 5000ns
WaveRestoreZoom {0 ps} {500 ns}