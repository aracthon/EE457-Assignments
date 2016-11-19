-------------------------------------------------------------------------------
-- File name: 	: consumer.vhd for fifo_reg_array_sc.vhd (sc = single clock)
-- Design       : consumer for fifo_reg_array_tc 
-- Project      : FIFO using register array (single clock)
-- Author       : Pritish Malavade and Gandhi Puvvada
-- Company      : University of Southern California 
-- Date			: 6/20/2010
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
use ieee.std_logic_textio.all;
---------------------------------------
entity consumer is
port (
		reset	: in    std_logic;
		empty 	: in 	std_logic;
		ren		: out 	std_logic;
		data_to_consume	: in	std_logic_vector(15 downto 0);
		rclk		: in 	std_logic
	);
end consumer;
------------------------------------------------------------------------------
architecture behv of consumer is


type mem_type is array (0 to 63) of std_logic_vector(15 downto 0); 
signal con_mem : mem_type;

signal consumeptr			:std_logic_vector(5 downto 0);
signal counter			:std_logic_vector(2 downto 0);
signal rclk_clock_count: integer range 0 to 9999;
---------------------------------------
begin
---------------------------------------
	Clock_counting: process(rclk, reset)
	begin
		if (reset = '1') then
			rclk_clock_count <= 0;
		elsif (rclk'event and rclk = '1') then
			rclk_clock_count <= rclk_clock_count + 1;
		end if;
	end process Clock_counting;
---------------------------------------
ren_process: process(data_to_consume, counter)
begin
	if (
		(data_to_consume(2 downto 0) = "000" or data_to_consume(2 downto 0) = "001") 
		or
		(counter = data_to_consume(2 downto 0)) 
	   )  then 
	ren <= '1';
	else ren <= '0';
	end if;
end process ren_process;
---------------------------------------
receive_process: process (rclk)
  file received_data_file: text open write_mode is "ee457_received_data.txt";
  file received_data_hex_alone_file: text open write_mode is "ee457_received_data_hex_alone.txt";
		variable outline : line;
  begin
	if(reset = '1') then
	
	consumeptr <= (others => '0');
	counter <= (others => '0');
	
	elsif(rclk'event and rclk ='1') then
	   		if ( empty ='0') then -- we are careful in consuming by checking to see that it is not garbage
			if (
				(data_to_consume(2 downto 0) = "000" or data_to_consume(2 downto 0) = "001") 
				or
				(counter = data_to_consume(2 downto 0)) 
			   )  then 
					con_mem(CONV_INTEGER(consumeptr))     <= data_to_consume; 
					consumeptr <= consumeptr + 1;
					hwrite( outline, data_to_consume); -- hwrite = write in hex format
					write( outline, string'(" clock_count = "));
					write( outline, rclk_clock_count);
					write( outline, character'(ht)); -- horizontal tab character
					write( outline, string'(" time = "));
					write( outline, now); -- "now" refers to the current simulation time in VHDL. 
					writeline(received_data_file, outline);
					
					hwrite( outline, data_to_consume); -- hwrite = write in hex
					writeline(received_data_hex_alone_file, outline);
					
					counter <= (others => '0');
				else
					counter <= counter + 1;
				end if;
			end if;
	end if;
		
end process receive_process;
---------------------------------------
end behv;