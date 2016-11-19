# min_max_finder_part1_wave.do
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /min_max_finder_part1_tb/UUT/Reset
add wave -noupdate -format Logic -radix hexadecimal /min_max_finder_part1_tb/UUT/Clk
add wave -noupdate -format Logic -radix hexadecimal /min_max_finder_part1_tb/UUT/Start
add wave -noupdate -format Logic -radix hexadecimal /min_max_finder_part1_tb/UUT/Qi
add wave -noupdate -format Logic -radix hexadecimal /min_max_finder_part1_tb/UUT/Ql
add wave -noupdate -format Logic -radix hexadecimal /min_max_finder_part1_tb/UUT/Qc
add wave -noupdate -format Logic -radix hexadecimal /min_max_finder_part1_tb/UUT/Qd
add wave -noupdate -format Literal -radix hexadecimal /min_max_finder_part1_tb/UUT/state
add wave -noupdate -format Literal -radix ascii /min_max_finder_part1_tb/state_string
add wave -noupdate -format Literal -radix hexadecimal /min_max_finder_part1_tb/UUT/Max
add wave -noupdate -format Literal -radix hexadecimal /min_max_finder_part1_tb/UUT/Min
add wave -noupdate -format Literal -radix hexadecimal /min_max_finder_part1_tb/UUT/I
add wave -noupdate -format Literal -radix hexadecimal /min_max_finder_part1_tb/M_of_I
add wave -noupdate -format Literal -radix hexadecimal /min_max_finder_part1_tb/test_number
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {65 ns} 0} {{Cursor 2} {110 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 52
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update

