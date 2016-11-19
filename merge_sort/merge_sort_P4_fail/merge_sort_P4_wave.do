onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /merge_sort_P4_tb/UUT/Reset
add wave -noupdate -radix binary /merge_sort_P4_tb/UUT/Clk
add wave -noupdate -radix binary /merge_sort_P4_tb/UUT/Start
add wave -noupdate -radix binary /merge_sort_P4_tb/UUT/Ack
add wave -noupdate -radix unsigned /merge_sort_P4_tb/UUT/I
add wave -noupdate -radix unsigned /merge_sort_P4_tb/UUT/As_of_I
add wave -noupdate -radix unsigned /merge_sort_P4_tb/UUT/J
add wave -noupdate -radix unsigned /merge_sort_P4_tb/UUT/Bs_of_J
add wave -noupdate -radix unsigned /merge_sort_P4_tb/UUT/K
add wave -noupdate -radix unsigned /merge_sort_P4_tb/UUT/Cs_of_K
add wave -noupdate -radix unsigned /merge_sort_P4_tb/UUT/L
add wave -noupdate -radix unsigned /merge_sort_P4_tb/UUT/Ms_of_L
add wave -noupdate -radix binary /merge_sort_P4_tb/UUT/Ms_of_L_Write
add wave -noupdate -radix binary /merge_sort_P4_tb/UUT/Clk
add wave -noupdate -radix unsigned /merge_sort_P4_tb/UUT/state
add wave -noupdate -radix ascii /merge_sort_P4_tb/state_string
add wave -noupdate -radix unsigned /merge_sort_P4_tb/Clk_cnt
add wave -noupdate -radix unsigned /merge_sort_P4_tb/Start_clock_count
add wave -noupdate -radix unsigned /merge_sort_P4_tb/Clocks_taken
add wave -noupdate -radix unsigned /merge_sort_P4_tb/testcase_number
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {230000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 100
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {268325 ps}
