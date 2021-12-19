-------------------------------------
--VHDL Version: 1076-2008
--Tool name:	Aldec Active HDL 11.1
--Module Name:  reg_file
--Description:  Register file - contains the registers MM0-MM7 as well as
--processes for reading and writing the register file
-------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is
	port(  
	clk: in std_logic;                           --clock
	
	instr: in std_logic_vector(23 downto 0);     --instruction from instruction buffer
	
	wrt_enable: in std_logic;                    --active high write enable
	reg_write:  in std_logic_vector(2 downto 0); --selects register to write 
	wrt_data: in std_logic_vector(63 downto 0);  --register value to write
	
	src_out:  out std_logic_vector(63 downto 0); --output data
	dest_out: out std_logic_vector(63 downto 0)
	);
end reg_file;	

architecture beh of reg_file is

type vec_array64 is array(natural range <>) of std_logic_vector(63 downto 0);	
signal reg_array: vec_array64(7 downto 0)               --Registers MM0-MM7
                        := (others => (others => '0')); --initialize entire register file to zeros

begin
	
	read:  --Combinationally read a value from the register file
	process(instr,clk,wrt_enable,reg_write,wrt_data,reg_array) 
	variable src_read:  std_logic_vector(2 downto 0) := "000"; --selects registers to read
	variable dest_read: std_logic_vector(2 downto 0) := "000";
	begin  
		
		src_read  := instr(5 downto 3);
		dest_read := instr(2 downto 0);
		
		--Output appropriate register values--
		src_out  <= reg_array( to_integer(unsigned(src_read)) );
		dest_out <= reg_array( to_integer(unsigned(dest_read)) );
			
	end process;  
		
	write: --Sequentially write a value to the register file
	process(instr,clk,wrt_enable,reg_write,wrt_data,reg_array)	 
	variable reg_num: integer;
	begin		
		if(falling_edge(clk)) then		
			if(wrt_enable = '1') then
				reg_num := to_integer(unsigned(reg_write));
				reg_array(reg_num) <= wrt_data;
				end if;	
			end if;
	end process;
	
end beh;
