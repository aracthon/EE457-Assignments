// File name: 	: fifo_reg_array_sc_n_bit_pointers.v (sc = single clock)
// Design       : fifo_reg_array_sc 
// Author       : Gandhi Puvvada
// Date			: 10/24/2014
// Here, we use only n-bit pointers for wrptr and rdptr, instead of (n+1) bit pointers.
// Signals almost_empty and almost_full are used so that when the two pointers meet, we know, whether the fifo is actually
// full or empty. Note that this method works only for single clock fifo.
// Modified on 10/30/2014: signal "depth" is added to the port list

`timescale 1 ns/100 ps

module fifo_reg_array_sc (clk, reset, data_in, wen, ren, data_out, depth, empty, full);

parameter DATA_WIDTH = 16;
parameter ADDR_WIDTH = 4;

input clk, reset;
input wen, ren; // the read or write request for CPU
input [DATA_WIDTH-1:0] data_in;

output [DATA_WIDTH-1:0] data_out;
output [ADDR_WIDTH-1:0] depth;
output empty, full;

reg [ADDR_WIDTH-1:0] rdptr, wrptr; //read pointer and write pointer of FIFO
wire [ADDR_WIDTH-1:0] depth;
wire wenq, renq;// read and write enable for FIFO
reg full, empty;

reg [DATA_WIDTH-1:0] Reg_Array [(2**ADDR_WIDTH)-1:0];// FIFO array
reg AE_AF_flag; // zero means almost empty and one means almost full
wire  raw_almost_empty, raw_almost_full;


wire [ADDR_WIDTH-1:0] lower_of_lower_two_thresholds  = {1'b0, 1'b1, {(ADDR_WIDTH - 2){1'b0}}};
wire [ADDR_WIDTH-1:0] upper_of_lower_two_thresholds  = {1'b0, 1'b1, {(ADDR_WIDTH - 2){1'b1}}};
wire [ADDR_WIDTH-1:0] lower_of_higher_two_thresholds = {1'b1, 1'b0, {(ADDR_WIDTH - 2){1'b0}}};
wire [ADDR_WIDTH-1:0] upper_of_higher_two_thresholds = {1'b1, 1'b0, {(ADDR_WIDTH - 2){1'b1}}};
wire [ADDR_WIDTH-1:0] N_zeros = {(ADDR_WIDTH){1'b0}};


assign depth = wrptr - rdptr;
//task #1: fill in the blanks for signals "raw_almost_empty" and "raw_almost_full". 

assign raw_almost_empty = ((depth >= lower_of_lower_two_thresholds) && (depth <= upper_of_lower_two_thresholds)) ? 1 : 0; 
// basically means whenever the higher two bits are 01, we set the raw-almost-empty signal.

assign raw_almost_full  = ((depth >= lower_of_higher_two_thresholds) && (depth <= upper_of_higher_two_thresholds)) ? 1 : 0; 
// basically means whenever the higher two bits are 10, we set the raw-almost-full signal.


always@(*)
begin
	empty = 1'b0;
	full = 1'b0;
//task #2: fill in the conditions for signal "empty" and "full".
	if ( (AE_AF_flag == 0) && depth == 0)
		empty = 1'b1;
	if ( (AE_AF_flag == 1) && depth == 0)  
		full = 1'b1;
end

assign wenq = (~full) & wen;// only if the FIFO is not full and there is write request from CPU, we enable the write to FIFO.
assign renq = (~empty)& ren;// only if the FIFO is not empty and there is read request from CPU, we enable the read to FIFO.
assign data_out = Reg_Array[rdptr];

always@(posedge clk, posedge reset)
begin
    if (reset)
		begin
			wrptr <= N_zeros;
			rdptr <= N_zeros;
			AE_AF_flag <= 1'b0;
		end
	else
		begin
			if (wenq)  
				begin
// task #3: complete this block.
					Reg_Array[wrptr] <= data_in;
					wrptr <= wrptr + 1;
				end
			if (renq)
					rdptr <= rdptr + 1;
// task #4: complete set and reset of AE_AF_flag (zero means almost empty and one means almost full).
			if ( ~(raw_almost_full == 1 && AE_AF_flag == 0 || raw_almost_empty == 0 && AE_AF_flag == 1) ) begin
				AE_AF_flag <= 1'b0;
			end
			else if ( (raw_almost_full == 1 && AE_AF_flag == 0 || raw_almost_empty == 0 && AE_AF_flag == 1) ) begin
				AE_AF_flag <= 1'b1;
			end
		end
end

endmodule