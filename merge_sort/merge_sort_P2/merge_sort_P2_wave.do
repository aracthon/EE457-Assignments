onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /merge_sort_P2_tb/UUT/Reset
add wave -noupdate /merge_sort_P2_tb/UUT/Clk
add wave -noupdate /merge_sort_P2_tb/UUT/Start
add wave -noupdate /merge_sort_P2_tb/UUT/Ack
add wave -noupdate -radix unsigned /merge_sort_P2_tb/UUT/I
add wave -noupdate -radix unsigned /merge_sort_P2_tb/UUT/Ps_of_I
add wave -noupdate -radix unsigned /merge_sort_P2_tb/UUT/J
add wave -noupdate -radix unsigned /merge_sort_P2_tb/UUT/Qs_of_J
add wave -noupdate -radix unsigned /merge_sort_P2_tb/UUT/K
add wave -noupdate -radix unsigned /merge_sort_P2_tb/UUT/Rs_of_K
add wave -noupdate /merge_sort_P2_tb/UUT/Rs_of_K_Write
add wave -noupdate /merge_sort_P2_tb/UUT/Clk
add wave -noupdate -radix unsigned /merge_sort_P2_tb/UUT/state
add wave -noupdate -radix ascii /merge_sort_P2_tb/state_string
add wave -noupdate /merge_sort_P2_tb/Clk_cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {210000 ps} 0}
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
WaveRestoreZoom {0 ps} {757070 ps}
