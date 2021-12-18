-------------------------------------
--VHDL Version: 1076-2008
--Tool name:	Aldec Active HDL 11.1
--Module Name:  forwarding_unit
--Description:  Compares the register currently being written in WB stage
--to ALU operands and carries out any necessary forwarding
-------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forwarding_unit is	   
	port(		
	src_in:  in std_logic_vector(63 downto 0);      --input register data
	dest_in: in std_logic_vector(63 downto 0);	
	instr_ex_wb: in std_logic_vector(23 downto 0);  --instruction output of ex_wb register
	instr_id_ex: in std_logic_vector(23 downto 0);  --instruction output of id_ex register 
	wb_data: in std_logic_vector(63 downto 0);      --write-back data 
	wb_enable: in std_logic;                        --write-back enable
	
	src_out:  out std_logic_vector(63 downto 0);    --output register data
	dest_out: out std_logic_vector(63 downto 0)
	);
end forwarding_unit;

architecture beh of forwarding_unit is
begin  
	
	forward:
	process(src_in, dest_in, instr_ex_wb, instr_id_ex, wb_data, wb_enable)
	variable wb_dest: std_logic_vector(2 downto 0) := "000"; --destination of write-back
	variable src:  std_logic_vector(2 downto 0) := "000";    --source for instruction to be executed by ALU
	variable dest: std_logic_vector(2 downto 0) := "000";	 --destination for instruction to be executed by ALU
	begin	
		
		wb_dest := instr_ex_wb(2 downto 0);
		src  := instr_id_ex(5 downto 3);
		dest := instr_id_ex(2 downto 0);
		
		src_out  <= src_in;
		dest_out <=	dest_in;   
		
		if(wb_enable = '1') then
			if(wb_dest = src) then   --if the src for the current ALU instruction is the register currently being written, we need to forward	
				src_out <= wb_data;
			end if;	
			
			if(wb_dest = dest) then  --if the dest for the current ALU instruction is the register currently being written, we need to forward
				dest_out <= wb_data;
			end if;	  
		end if;
		
	end process;
	
end beh;