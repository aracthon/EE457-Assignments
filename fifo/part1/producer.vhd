-------------------------------------------------------------------------------
-- File name: 	: producer.vhd for fifo_reg_array_sc.vhd (sc = single clock)
-- Design       : fifo_reg_array_sc 
-- Project      : FIFO using register array (single clock)
-- Author       : Gandhi Puvvada
-- Company      : University of Southern California 
-- Date			: 6/21/2010
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;
---------------------------------------
entity producer is
port (
		reset			: in    std_logic;
		full 			: in 	std_logic;
		wen				: out 	std_logic;
		data_to_send	: out	std_logic_vector(15 downto 0);
		wclk			: in 	std_logic
	);
end producer;
------------------------------------------------------------------------------
architecture behv of producer is

type mem_type is array (0 to 63) of std_logic_vector(15 downto 0); 
signal data_in_array : mem_type; -- this array is filled with data from the "ee560_producer_data.txt" file at reset
signal prod_mem : mem_type; -- the producer deposits in this memory a copy of the item conveyed to the FIFO
type integer_mem_type is array (0 to 63) of integer; 
signal data_in_latency_array: integer_mem_type; -- this array is filled with latencies from the "ee560_producer_data.txt" file at reset

signal wen_int			: std_logic;
signal producerptr		:std_logic_vector(5 downto 0); -- 6-bit producer pointer into the producer memory prod_mem
signal max_producerptr	:std_logic_vector(5 downto 0); -- max value for the producerptr (it depends upon how many data are in the "ee560_producer_data.txt" file. 
signal latency_counter			:std_logic_vector(6 downto 0);
signal wclk_clock_count: integer range 0 to 9999;
signal data_to_send_internal    : std_logic_vector(15 downto 0); 
---------------------------------------
begin
---------------------------------------
	Clock_counting: process(wclk, reset)
	begin
		if (reset = '1') then
			wclk_clock_count <= 0;
		elsif (wclk'event and wclk = '1') then
			wclk_clock_count <= wclk_clock_count + 1;
		end if;
	end process Clock_counting;
---------------------------------------	
-- combinational operations as part of sending data to the FIFO
data_to_send <=  data_to_send_internal;
data_to_send_internal <= ( data_in_array (CONV_INTEGER(producerptr) ) ) when (wen_int = '1') else (others => 'Z');
wen_int <= '1' when ( 
				  (data_in_latency_array(CONV_INTEGER(producerptr)) = latency_counter) 
				  and
				  (producerptr < max_producerptr)
				)
		else '0';
wen <= wen_int;
---------------------------------------
-- sequential part of the send process
send_process: process (wclk)
		file producer_data_file: text open read_mode is "ee457_producer_data.txt";
		file sent_data_file: text open write_mode is "ee457_sent_data.txt";
		file sent_data_hex_alone_file: text open write_mode is "ee457_sent_data_hex_alone.txt";
		variable inline : line; -- line read from the producer_data file ee560_producer_data.txt
		variable outline : line; -- line to be written to the sent_data file ee560_sent_data.txt
		variable data_to_be_sent : std_logic_vector(15 downto 0);
		variable send_cycles_to_wait: integer;
		variable max_producerptr_recorded : boolean := false;
 begin
	if(reset = '1') then
	
		producerptr <= (others => '0');
		latency_counter <= (others => '0');
		-- On reset, let us readout the entire content of the "ee560_producer_data.txt" file into local memories (arrays).
		for I in 0 to 63 loop
			if (not endfile( producer_data_file))  then
					readline(producer_data_file, inline);
					read(inline, send_cycles_to_wait);
					hread(inline, data_to_be_sent); -- hread = read hex data
					data_in_latency_array(I) <= send_cycles_to_wait;
					data_in_array(I) <= data_to_be_sent;
			elsif (not max_producerptr_recorded) then
				max_producerptr_recorded := true;
				max_producerptr <= CONV_STD_LOGIC_VECTOR (I, 6);
			end if;
		end loop;
	
	elsif(wclk'event and wclk ='1') then
		if (data_in_latency_array(CONV_INTEGER(producerptr)) = latency_counter) then
				if (( full ='0') and (producerptr < max_producerptr) ) then 
					producerptr <= producerptr + 1;
					hwrite( outline, data_to_send_internal); -- hwrite = write in hex
					write( outline, string'(" clock_count = "));
					write( outline, wclk_clock_count);
					write( outline, character'(ht)); -- horizontal tab character
					write( outline, string'(" time = "));
					write( outline, now); -- "now" refers to the current simulation time in VHDL. 
					writeline(sent_data_file, outline);
					
					write ( outline, CONV_INTEGER(unsigned(latency_counter)));
					write( outline, character'(ht)); -- horizontal tab character
					hwrite( outline, data_to_send_internal); -- hwrite = write in hex
					writeline(sent_data_hex_alone_file, outline);
					latency_counter <= (others => '0');
					if (producerptr = (max_producerptr -1) ) then
						assert (false) report "End of Producer File" severity note;
					end if;
				end if;
		else
			latency_counter <= latency_counter + 1;
		end if;
	end if;
		
end process send_process;
---------------------------------------

end behv;
