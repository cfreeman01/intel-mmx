-------------------------------------
--VHDL Version: 1076-2008
--Tool name:	Aldec Active HDL 11.1
--Module Name:  mmx_unit
--Description:  Top-level, pipelined unit to execute Intel MMX instruction set
-------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	
use work.all;

entity mmx_unit is
	port(
	clk: in std_logic;	
	PC: in integer;                                  --program counter input to instruction buffer
	instr_written: in std_logic_vector(23 downto 0); --instruction to write to instruction buffer
	ib_wrt_enable: in std_logic                      --wrt_enable input to instruction buffer
	);
end mmx_unit;

architecture struct of mmx_unit is 

--***--INTERCONNECTING SIGNALS--***--  
--IF
signal instr_buff_out:  std_logic_vector(23 downto 0);  --output of instruction buffer

--ID
signal instr_if_id_out: std_logic_vector(23 downto 0);            --output of if_id inter-stage register  
signal src_reg_out, dest_reg_out: std_logic_vector(63 downto 0);  --outputs of register file	
signal src_fwd_out, dest_fwd_out: std_logic_vector(63 downto 0);  --outputs of forwarding unit

--EX
signal src_id_ex_out, dest_id_ex_out: std_logic_vector(63 downto 0); --register outputs of id_ex inter-stage register
signal instr_id_ex_out: std_logic_vector(23 downto 0);               --instruction output of id_ex register
signal alu_out: std_logic_vector(63 downto 0);                       --ALU result	

--WB
signal rf_wrt_enable: std_logic;                        --wrt_enable input to register file
signal instr_ex_wb_out: std_logic_vector(23 downto 0);	--instruction output of ex_wb inter-stage register	
signal data_ex_wb_out: std_logic_vector(63 downto 0);   --instruction output of ex_wb inter-stage register
														 
begin 
	
--***--COMPONENT INSTANTIATIONS--***-- 
--Instruction Buffer-- 
instr_buffer: entity instr_buffer port map(
	clk => clk, 	
	PC => PC,
	wrt_enable => ib_wrt_enable,
	instr_written => instr_written, 
	instr_fetched => instr_buff_out
	);
	
--Register File--
reg_file: entity reg_file port map(
	clk=>clk, 
	instr => instr_if_id_out,
	src_out => src_reg_out,
	dest_out => dest_reg_out,	
	wrt_enable => rf_wrt_enable,
	reg_write => instr_ex_wb_out(2 downto 0),
	wrt_data => data_ex_wb_out
	);	
	
--Forwarding unit--
forwarding_unit: entity forwarding_unit port map(
	src_in => src_id_ex_out, 
	dest_in => dest_id_ex_out, 
	instr_ex_wb => instr_ex_wb_out,
	instr_id_ex => instr_id_ex_out,
	wb_data => data_ex_wb_out,
	wb_enable => rf_wrt_enable,
	src_out => src_fwd_out,
	dest_out => dest_fwd_out
	);
		
--ALU--
alu: entity alu port map( 
	src => src_fwd_out, 
	dest => dest_fwd_out, 
	ins => instr_id_ex_out,
	res => alu_out
	);	
		
--***--INTER-STAGE REGISTERS--***-- 
IF_ID:
process(clk)
begin
	if(rising_edge(clk)) then
		instr_if_id_out <= instr_buff_out;
	end if;
end process; 

ID_EX:
process(clk)
begin
	if(rising_edge(clk)) then
		src_id_ex_out <= src_reg_out; 
		dest_id_ex_out <= dest_reg_out;
		instr_id_ex_out <= instr_if_id_out;
	end if;
end process; 

EX_WB:
process(clk)
begin  		
	if(rising_edge(clk)) then		
		instr_ex_wb_out <= instr_id_ex_out;
		data_ex_wb_out <= alu_out;
	end if;
end process;

write_back:
process(instr_ex_wb_out, data_ex_wb_out)
begin  
	case instr_ex_wb_out(23 downto 17) is
			when "0000000" => rf_wrt_enable <= '1';
			when "0000001" => rf_wrt_enable <= '1'; 
			when "0000010" => rf_wrt_enable <= '1';      
			when "0000011" => rf_wrt_enable <= '1'; 
			when "0000100" => rf_wrt_enable <= '1';	
			when "0000101" => rf_wrt_enable <= '1';
			when "0000110" => rf_wrt_enable <= '1';
			when "0000111" => rf_wrt_enable <= '1';
			when "0001000" => rf_wrt_enable <= '1';
			when "0001001" => rf_wrt_enable <= '1';
			when "0001010" => rf_wrt_enable <= '1';
			when "0001011" => rf_wrt_enable <= '1';
			when "0001100" => rf_wrt_enable <= '1'; 
			when "0001101" => rf_wrt_enable <= '1';
			when "0001110" => rf_wrt_enable <= '1';
			when "0001111" => rf_wrt_enable <= '1';	
			when "0010000" => rf_wrt_enable <= '1';	
			when "0010001" => rf_wrt_enable <= '1';
			when "0010010" => rf_wrt_enable <= '1';	
			when "0010011" => rf_wrt_enable <= '1';	
			when "0010100" => rf_wrt_enable <= '1';
			when "0010101" => rf_wrt_enable <= '1';
			when "0010110" => rf_wrt_enable <= '1';
			when "0010111" => rf_wrt_enable <= '1';
			when "0011000" => rf_wrt_enable <= '1';	
			when "0011001" => rf_wrt_enable <= '1';	 
			when "0011010" => rf_wrt_enable <= '1';
			when others => rf_wrt_enable <= '0';			
		end case; 
end process;

end struct;