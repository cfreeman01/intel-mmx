-------------------------------------
--VHDL Version: 1076-2008
--Tool name:	Aldec Active HDL 11.1
--Module Name:  instr_buffer
--Description:  Contains a buffer that stores 3-byte instructions and also
--contains processes for reading and writing the buffer
-------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_buffer is
	port(	  
	clk:        in std_logic;  --clock 
	PC:         in integer;    --program counter
	wrt_enable: in std_logic;  --determines whether buffer will be written or read on clock edge   
	instr_written: in  std_logic_vector(23 downto 0); --instruction written
	instr_fetched: out std_logic_vector(23 downto 0)  --instruction fetched
	);			   
end instr_buffer;	


architecture beh of instr_buffer is 	 

type vec24_array is array(natural range <>) of std_logic_vector(23 downto 0);	 
signal instr_array: vec24_array(0 to 127); --instruction buffer holds 128 instructions

begin 
	
	instr_fetch:  --Fetch an instruction combinationally
	process(PC, instr_written) 
	begin		 
		if(wrt_enable = '0') then
			instr_fetched <= instr_array(PC);
		end if;
	end process;  
	
	instr_write:  --Sequentially write instruction to next empty location in the buffer   
	process(clk) 
	variable wrt_loc: integer := 0;	
	begin
		
		if(rising_edge(clk)) then
			if(wrt_enable = '1') then
				instr_array(wrt_loc) <= instr_written;
				wrt_loc := wrt_loc + 1;
			end if;
		end if;
	
	end process; 

	end beh;