onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider PRODUCER
add wave -noupdate -format Logic /fifo_tb/prod/reset
add wave -noupdate -format Logic /fifo_tb/prod/full
add wave -noupdate -format Logic /fifo_tb/prod/wen
add wave -noupdate -format Literal -radix hexadecimal /fifo_tb/prod/data_to_send
add wave -noupdate -format Literal -radix hexadecimal /fifo_tb/prod/prod_mem
add wave -noupdate -format Literal -radix hexadecimal /fifo_tb/prod/producerptr
add wave -noupdate -format Literal -radix hexadecimal /fifo_tb/prod/latency_counter
add wave -noupdate -format Literal /fifo_tb/prod/wclk_clock_count
add wave -noupdate -divider FIFO
add wave -noupdate -format Logic /fifo_tb/fifo/clk
add wave -noupdate -format Logic /fifo_tb/fifo/reset
add wave -noupdate -format Literal -radix hexadecimal /fifo_tb/fifo/data_in
add wave -noupdate -format Logic /fifo_tb/fifo/wen
add wave -noupdate -format Logic /fifo_tb/fifo/ren
add wave -noupdate -format Literal -radix hexadecimal /fifo_tb/fifo/data_out
add wave -noupdate -format Logic /fifo_tb/fifo/empty
add wave -noupdate -format Logic /fifo_tb/fifo/full
add wave -noupdate -format Literal -radix hexadecimal -expand /fifo_tb/fifo/Reg_Array
add wave -noupdate -format Literal -radix hexadecimal /fifo_tb/fifo/rdptr
add wave -noupdate -format Literal -radix hexadecimal /fifo_tb/fifo/wrptr
add wave -noupdate -format Literal -radix hexadecimal /fifo_tb/fifo/depth
add wave -noupdate -format Logic /fifo_tb/fifo/wenq
add wave -noupdate -format Logic /fifo_tb/fifo/renq
add wave -noupdate -divider CONSUMER
add wave -noupdate -format Logic /fifo_tb/cons/reset
add wave -noupdate -format Logic /fifo_tb/cons/empty
add wave -noupdate -format Logic /fifo_tb/cons/ren
add wave -noupdate -format Literal -radix hexadecimal /fifo_tb/cons/data_to_consume
add wave -noupdate -format Literal -radix hexadecimal /fifo_tb/cons/con_mem
add wave -noupdate -format Literal -radix hexadecimal /fifo_tb/cons/consumeptr
add wave -noupdate -format Literal -radix hexadecimal /fifo_tb/cons/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5045778 ps} 0} {{Cursor 2} {9736853 ps} 0} {{Cursor 3} {3470000 ps} 0}
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
WaveRestoreZoom {3331079 ps} {3622951 ps}
