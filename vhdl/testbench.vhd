-------------------------------------
--VHDL Version: 1076-2008
--Tool name:	Aldec Active HDL 11.1
--Module Name:  testbench
--Description:  Testbench to evaluate the mmx_unit module
-------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  
use STD.textio.all;
use ieee.std_logic_textio.all;
use work.all;

entity testbench is
end testbench;	 

architecture beh of testbench is  

--TYPE DEFINITIONS--
type char_file is file of character;  --file of 32-bit integers (used for input) 
	
--LOCAL SIGNALS--  
signal PC: integer;             --program counter
signal clk: std_logic := '0';	--clock
signal instr_written: std_logic_vector(23 downto 0);  --input to write instruction buffer
signal ib_wrt_enable: std_logic;  --wrt_enable input to instrution buffer

begin  	
	
	--Unit Under Test--
	uut: entity mmx_unit port map(clk => clk,
		PC => PC,
		instr_written => instr_written,
		ib_wrt_enable => ib_wrt_enable); 
	
	--Main process--
	tb: 
	process is 	 
	
	--Timing
	constant period:     time    := 2ns;
	variable tot_cycles: integer := 4;  --total number of cycles to run simulation for (increments as we read instructions)
	
	--File I/O
	file input_file:      char_file open read_mode  is "assembler_output.bin"; 
	file results_file:    text      open write_mode is "results.txt"; 
	variable out_line:    line;
	variable char_read:   character;	   		 
	variable instr_read:  std_logic_vector(23 downto 0);  
	
	--Type definitions
	type vec_array64 is array(natural range <>) of std_logic_vector(63 downto 0);
	
	--Aliases for Signals in the Multimedia Unit
	alias instr_buff_out  is <<signal .testbench.uut.instr_buff_out : std_logic_vector>>;
	alias instr_if_id_out is <<signal .testbench.uut.instr_if_id_out : std_logic_vector>>; 
	alias src_id_ex_out   is <<signal .testbench.uut.src_id_ex_out: std_logic_vector>>;  
	alias dest_id_ex_out  is <<signal .testbench.uut.dest_id_ex_out: std_logic_vector>>;
	alias src_fwd_out     is <<signal .testbench.uut.src_fwd_out: std_logic_vector>>;  
	alias dest_fwd_out    is <<signal .testbench.uut.dest_fwd_out: std_logic_vector>>;
    alias instr_alu_in    is <<signal .testbench.uut.instr_id_ex_out : std_logic_vector>>;
    alias alu_out         is <<signal .testbench.uut.alu_out : std_logic_vector>>;		
	alias reg_file        is <<signal .testbench.uut.reg_file.reg_array: vec_array64>>;
	alias rf_wrt_enable   is <<signal .testbench.uut.rf_wrt_enable: std_logic>>;
	alias data_ex_wb_out  is <<signal .testbench.uut.data_ex_wb_out: std_logic_vector>>;  
	alias instr_ex_wb_out is <<signal .testbench.uut.instr_ex_wb_out: std_logic_vector>>;
		
	begin	
		
		---READ INSTRUCTION FILE AND WRITE TO INSTRUCTION BUFFER---	 
		ib_wrt_enable <= '1'; 
		clk <= '0';
		while not endfile(input_file) loop	 
			read(input_file, char_read);
			instr_read(23 downto 16) := std_logic_vector(to_unsigned(character'POS(char_read), 8));
			read(input_file, char_read);
			instr_read(15 downto 8) := std_logic_vector(to_unsigned(character'POS(char_read), 8));
			read(input_file, char_read);
			instr_read(7 downto 0) := std_logic_vector(to_unsigned(character'POS(char_read), 8));
			
			instr_written <= instr_read;  --set the instr_written input to the instruction read from file
			tot_cycles := tot_cycles + 1; --increment cycle count 
			
			wait for period/2;  --run one cycle (write the instruction buffer)
			clk <= not clk;
			wait for period/2;
			clk <= not clk;
		end loop;  
		file_close(input_file);
		
		ib_wrt_enable <= '0';  	 
		PC <= 0;		 
		
		---EXECUTE THE INSTRUCTIONS AND WRITE STATUS TO FILE---
		for i in 0 to tot_cycles loop  
						
			wait for period/2;  
			
			write(out_line, "==============CYCLE ");
			write(out_line, i);
			write(out_line, "==============");
			writeLine(results_file, out_line);
			
			--------------------IF STAGE--------------------
			write(out_line, "Instruction buffer output: ", left, 50);
			write(out_line, "0x" & to_hstring(unsigned(instr_buff_out)));
			writeLine(results_file, out_line);	
			
			--------------------ID STAGE--------------------
			write(out_line, "IF/ID register output: ", left, 50);
			write(out_line, "0x" & to_hstring(unsigned(instr_if_id_out)));
			writeLine(results_file, out_line);	 	 
			
			--------------------EX STAGE-------------------- 
			write(out_line, "ALU Src Input: ", left, 50); 
			write(out_line, "mm" & integer'image(to_integer(unsigned(instr_alu_in(5 downto 3))))); 
			writeLine(results_file, out_line); 
			
			write(out_line, "ALU Dest Input: ", left, 50); 
			write(out_line, "mm" & integer'image(to_integer(unsigned(instr_alu_in(2 downto 0)))));
			writeLine(results_file, out_line); 
			
			write(out_line, "ALU Input Instruction:", left, 50);
			write(out_line, "0x" & to_hstring(unsigned(instr_alu_in)));
			writeLine(results_file, out_line); 
			
			write(out_line, "ALU Output:", left, 50);
			write(out_line, "0x" & to_hstring(unsigned(alu_out)));
			writeLine(results_file, out_line);
			
			--------------------WB STAGE--------------------
			write(out_line, "Write Enable:", left, 50);
			write(out_line, std_logic'image(rf_wrt_enable));
			writeLine(results_file, out_line);
			
			if(rf_wrt_enable = '1') then   
				write(out_line, "Write Data:", left, 50);
				write(out_line, "0x" & to_hstring(unsigned(data_ex_wb_out)));
				writeLine(results_file, out_line);
				
				write(out_line, "Write Destination: ", left, 50); 
				write(out_line, "mm" & integer'image(to_integer(unsigned(instr_ex_wb_out(2 downto 0)))));
				writeLine(results_file, out_line);
			end if;	
			
			-------WRITE REGISTER FILE TO OUTPUT FILE-------
			write(out_line, "REGISTER FILE:", left, 50);
			writeLine(results_file, out_line);
			for i in 7 downto 0 loop
				write(out_line, "mm" & integer'image(i) & ":  ");
				write(out_line, to_hstring(unsigned(reg_file(i))));
				writeLine(results_file, out_line);
			end loop;
			
			--------------ADVANCE CLOCK AND PC--------------
			clk <= '1';
			wait for period/2;
			clk <= '0';			
			PC <= PC + 1;
			
		end loop; 
		file_close(results_file); 
		
		ib_wrt_enable <= '0';  
		clk <= '0';	 
		PC <= 0;
		wait for period;
		
		wait;
	end process;  	
	end beh;