
# fifo_reg_array_n_bit_pointers_sc.do

vlib work
vlog "fifo_reg_array_sc_n_bit_pointers_exercise.v" +acc
vcom "producer.vhd" +acc
vcom "consumer.vhd" +acc
vcom  "fifo_reg_array_n_bit_pointers_sc_tb.vhd" +acc
vsim -t 1ps -lib work fifo_tb
do {fifo_reg_array_sc_wave.do}
view wave
view structure
view signals
log -r *
run 11us
#update
WaveRestoreZoom {0 ns} {1200 ns}