# File name: ee457_lab7_P3.do

# This compiles the three verilog files, starts and runs simulation

vlib work
vlog +acc  "ee457_lab7_components.v" 
vlog +acc  "ee457_lab7_P3.v" 
vlog +acc  "ee457_lab7_P3_tb.v" 

vsim -novopt -t 1ps -lib work ee457_lab7_P3_tb

view wave
view structure
view signals
do ee457_lab7_P3_wave.do
log -r *
run 1ns
add memory -addressradix hex -dataradix  hex -wordsperline 8 UUT/REG_FILE/reg_file
examine -radix hex UUT/REG_FILE/reg_file
WaveRestoreZoom {40 ns} {240 ns}
#run 1199ns
#examine -radix hex UUT/REG_FILE/reg_file