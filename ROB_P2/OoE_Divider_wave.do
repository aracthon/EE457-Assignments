onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/Clk_tb
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/Reset_tb
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/Start_tb
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/complete_tb
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/single_div_states
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/rob_ready
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/stall
add wave -noupdate -format Literal /OoE_Divider_tb/OoE_DIV/state
add wave -noupdate -format Literal -radix ascii /OoE_Divider_tb/state_string
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/rob_full
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/no_divider_available
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/ack_from_OoE_div
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/start_from_OoE_div
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/mem_qr_pointer
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/mem_dd_pointer
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/memory_read_complete
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/memory_write_complete
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/rob_depth
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/rob_wp
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/rob_rp
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/rob_qr
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/dividend_of_OoE_div
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/divisor_of_OoE_div
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/quotient_of_OoE_div
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/remainder_of_OoE_div
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/clocks_of_single_div_completion_internal
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/mem_dividend_divisor
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/mem_quotient_remainder
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/mem_clocks_of_single_div_completion
add wave -noupdate -format Logic -radix hexadecimal /OoE_Divider_tb/OoE_DIV/mem_clocks_of_rob_graduation

#TreeUpdate [SetDefaultTree]
#WaveRestoreCursors {{Cursor 1} {21910000 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {500 ns}
