-------------------------------------
--VHDL Version: 1076-2008
--Tool name:	Aldec Active HDL 11.1
--Module Name:  alu_testbench
--Description:  Testbench to evaluate the alu module
-------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  
use work.all;

entity alu_testbench is
end alu_testbench;	 

architecture beh of alu_testbench is
--Stimulus signals
signal src, dest: std_logic_vector(63 downto 0);
signal ins: std_logic_vector(23 downto 0);

--Observed signals
signal res: std_logic_vector(63 downto 0);

begin  
	uut: entity alu port map(src=>src, dest=>dest, ins=>ins, res=>res);  --unit under test
		
		tb: process is 	
		constant period: time := 20ns; 
		begin		
			
			--pldi
			ins  <= B"0000000_11111111_101_000_000";
			src	 <= X"XX_XX_XX_XX_XX_XX_XX_XX";
			dest <=	X"FF_FF_00_FF_FF_FF_FF_FF";
			
			wait for period;  
			
			if(res = X"FF_FF_FF_FF_FF_FF_FF_FF") then	
				report "pldi: Success." severity note;
			else
				report "pldi: Failed." severity error;
			end if;
			wait for period;  		
			
			--movd
			ins  <= B"0000001_00000000_000_000_000";
			src	 <= X"FF_00_FF_00_FF_FF_FF_FF";
			dest <=	X"FF_F0_0F_00_00_00_00_00";
			
			wait for period;  
			
			if(res = X"00_00_00_00_FF_FF_FF_FF") then	
				report "movd: Success." severity note;
			else
				report "movd: Failed." severity error;
			end if;
			wait for period; 
			
			--movq	
			ins  <= B"0000010_00000000_000_000_000";
			src	 <= X"FF_00_FF_00_FF_FF_FF_FF";
			dest <=	X"FF_F0_0F_00_00_00_00_00";
			
			wait for period;  
			
			if(res = X"FF_00_FF_00_FF_FF_FF_FF") then	
				report "movq: Success." severity note;
			else
				report "movq: Failed." severity error;
			end if;
			wait for period;   
			
			--pand	  
			ins  <= B"0000011_00000000_000_000_000";
			src	 <= X"FF_00_FF_00_FF_FF_FF_FF";
			dest <=	X"FF_F0_0F_00_00_FF_FE_0A";
			
			wait for period;  
			
			if(res = X"FF_00_0F_00_00_FF_FE_0A") then	
				report "pand: Success." severity note;
			else
				report "pand: Failed." severity error;
			end if;
			wait for period; 
			
			--por 
			ins  <= B"0000100_00000000_000_000_000";
			src	 <= X"FF_00_FF_00_FF_FF_FF_FF";
			dest <=	X"FF_F0_0F_00_00_FF_FE_0A";
			
			wait for period;  
			
			if(res = X"FF_F0_FF_00_FF_FF_FF_FF") then	
				report "por: Success." severity note;
			else
				report "por: Failed." severity error;
			end if;
			wait for period; 
			
			--pandn
			ins  <= B"0000101_00000000_000_000_000";
			src	 <= X"FF_00_FF_00_FF_FF_FF_FF";
			dest <=	X"FF_F0_0F_00_00_FF_FE_0A";
			
			wait for period;  
			
			if(res = X"00_FF_F0_FF_FF_00_01_F5") then	
				report "pandn: Success." severity note;
			else
				report "pandn: Failed." severity error;
			end if;
			wait for period;
			
			--pxor
			ins  <= B"0000110_00000000_000_000_000";
			src	 <= X"FF_00_FF_00_FF_FF_FF_FF";
			dest <=	X"FF_F0_0F_00_00_FF_FE_0A";
			
			wait for period;  
			
			if(res = X"00_F0_F0_00_FF_00_01_F5") then	
				report "pxor: Success." severity note;
			else
				report "pxor: Failed." severity error;
			end if;
			wait for period; 
			
			--psllw
			ins  <= B"0000111_00000100_000_000_000";
			src	 <= X"XXXX_XXXX_XXXX_XXXX";
			dest <=	X"0400_0101_F000_000F";
			
			wait for period;  
			
			if(res = X"4000_1010_0000_00F0") then	
				report "psllw: Success." severity note;
			else
				report "psllw: Failed." severity error;
			end if;
			wait for period;  
			
			--pslld
			ins  <= B"0001000_00000100_000_000_000";
			src	 <= X"XXXX_XXXX_XXXX_XXXX";
			dest <=	X"04001001_F000000F";
			
			wait for period;  
			
			if(res = X"40010010_000000F0") then	
				report "pslld: Success." severity note;
			else
				report "pslld: Failed." severity error;
			end if;
			wait for period;
			
			--psllq
			ins  <= B"0001001_00000100_000_000_000";
			src	 <= X"XXXX_XXXX_XXXX_XXXX";
			dest <=	X"14000101F000000F";
			
			wait for period;  
			
			if(res = X"4000101F000000F0") then	
				report "psllq: Success." severity note;
			else
				report "psllq: Failed." severity error;
			end if;
			wait for period; 
			
			--psrlw
			ins  <= B"0001010_00000100_000_000_000";
			src	 <= X"XXXX_XXXX_XXXX_XXXX";
			dest <=	X"0400_0101_F000_000F";
			
			wait for period;  
			
			if(res = X"0040_0010_0F00_0000") then	
				report "psrlw: Success." severity note;
			else
				report "psrlw: Failed." severity error;
			end if;
			wait for period;  
			
			--psrld
			ins  <= B"0001011_00000100_000_000_000";
			src	 <= X"XXXX_XXXX_XXXX_XXXX";
			dest <=	X"04001001_F000000F";
			
			wait for period;  
			
			if(res = X"00400100_0F000000") then	
				report "psrld: Success." severity note;
			else
				report "psrld: Failed." severity error;
			end if;
			wait for period;
			
			--psrlq
			ins  <= B"0001100_00000100_000_000_000";
			src	 <= X"XXXX_XXXX_XXXX_XXXX";
			dest <=	X"14000101F000000F";
			
			wait for period;  
			
			if(res = X"014000101F000000") then	
				report "psrlq: Success." severity note;
			else
				report "psrlq: Failed." severity error;
			end if;
			wait for period; 
			
			--paddb
			ins  <= B"0001101_00000000_000_000_000";
			src	 <= X"00_01_FF_0F_0A_F0_F0_11";
			dest <=	X"00_10_01_01_02_0E_F0_11";
			
			wait for period;  
			
			if(res = X"00_11_00_10_0C_FE_E0_22") then	
				report "paddb: Success." severity note;
			else
				report "paddb: Failed." severity error;
			end if;
			wait for period;  
			
			--paddsb
			ins  <= B"0001110_00000000_000_000_000";
			src	 <= X"00_01_FF_0F_0A_F0_7F_80";
			dest <=	X"00_10_01_01_02_0E_01_FF";
			
			wait for period;  
			
			if(res = X"00_11_00_10_0C_FE_7F_80") then	
				report "paddsb: Success." severity note;
			else
				report "paddsb: Failed." severity error;
			end if;
			wait for period; 
			
			--paddusb
			ins  <= B"0001111_00000000_000_000_000";
			src	 <= X"00_01_FF_0F_0A_F0_7F_80";
			dest <=	X"00_10_01_01_02_0E_01_FF";
			
			wait for period;  
			
			if(res = X"00_11_FF_10_0C_FE_80_FF") then	
				report "paddusb: Success." severity note;
			else
				report "paddusb: Failed." severity error;
			end if;
			wait for period;
			
			--paddw
			ins  <= B"0010000_00000000_000_000_000";
			src	 <= X"000E_FF0F_FFFF_0000";
			dest <=	X"001F_0101_0001_0000";
			
			wait for period;  
			
			if(res = X"002D_0010_0000_0000") then	
				report "paddw: Success." severity note;
			else
				report "paddw: Failed." severity error;
			end if;
			wait for period;	 
			
			--paddsw
			ins  <= B"0010001_00000000_000_000_000";
			src	 <= X"000E_7FFF_8000_0000";
			dest <=	X"001F_0101_8001_0000";
			
			wait for period;  
			
			if(res = X"002D_7FFF_8000_0000") then	
				report "paddsw: Success." severity note;
			else
				report "paddsw: Failed." severity error;
			end if;
			wait for period;  
			
			--paddusw
			ins  <= B"0010010_00000000_000_000_000";
			src	 <= X"000E_7FFF_8000_0000";
			dest <=	X"001F_0101_8001_0000";
			
			wait for period;  
			
			if(res = X"002D_8100_FFFF_0000") then	
				report "paddusw: Success." severity note;
			else
				report "paddusw: Failed." severity error;
			end if;
			wait for period;
			
			--paddd
			ins  <= B"0010011_00000000_000_000_000";
			src	 <= X"70000000_FFFFFFFF";
			dest <=	X"00000005_000000AE";
			
			wait for period;  
			
			if(res = X"70000005_000000AD") then	
				report "paddd: Success." severity note;
			else
				report "paddd: Failed." severity error;
			end if;
			wait for period;  
			
			--packssdw
			ins  <= B"0010100_00000000_000_000_000";
			src	 <= X"80000000_7FFFFFFF";
			dest <=	X"00000005_000000AE";
			
			wait for period;  
			
			if(res = X"8000_7FFF_0005_00AE") then	
				report "packssdw: Success." severity note;
			else
				report "packssdw: Failed." severity error;
			end if;
			wait for period; 
			
			--packsswb
			ins  <= B"0010101_00000000_000_000_000";
			src	 <= X"8000_7FFF_00AE_800E";
			dest <=	X"FFFF_0005_0000_0010";
			
			wait for period;  
			
			if(res = X"80_7F_7F_80_FF_05_00_10") then	
				report "packsswb: Success." severity note;
			else
				report "packsswb: Failed." severity error;
			end if;
			wait for period;
			
			--packusdw
			ins  <= B"0010110_00000000_000_000_000";
			src	 <= X"80000000_7FFFFFFF";
			dest <=	X"00000005_000000AE";
			
			wait for period;  
			
			if(res = X"FFFF_FFFF_0005_00AE") then	
				report "packusdw: Success." severity note;
			else
				report "packusdw: Failed." severity error;
			end if;
			wait for period;
			
			--packuswb
			ins  <= B"0010111_00000000_000_000_000";
			src	 <= X"8000_7FFF_00AE_800E";
			dest <=	X"FFFF_0005_0000_0010";
			
			wait for period;  
			
			if(res = X"FF_FF_AE_FF_FF_05_00_10") then	
				report "packuswb: Success." severity note;
			else
				report "packuswb: Failed." severity error;
			end if;
			wait for period; 
			
			--punpcklbw
			ins  <= B"0011000_00000000_000_000_000";
			src	 <= X"80_00_7F_FF_00_AE_80_0E";
			dest <=	X"FF_FF_00_05_00_01_00_01";
			
			wait for period;  
			
			if(res = X"00_00_AE_01_80_00_0E_01") then	
				report "punpcklbw: Success." severity note;
			else
				report "punpcklbw: Failed." severity error;
			end if;
			wait for period;  
			
			--punpcklwd
			ins  <= B"0011001_00000000_000_000_000";
			src	 <= X"8000_7FFF_00AE_800E";
			dest <=	X"FFFF_0005_0001_0001";
			
			wait for period;  
			
			if(res = X"00AE_0001_800E_0001") then	
				report "punpcklwd: Success." severity note;
			else
				report "punpcklwd: Failed." severity error;
			end if;
			wait for period;
			
			--punpckldq
			ins  <= B"0011010_00000000_000_000_000";
			src	 <= X"80007FFF_00AE800E";
			dest <=	X"FFFF0005_00010001";
			
			wait for period;  
			
			if(res = X"00AE800E_00010001") then	
				report "punpckldq: Success." severity note;
			else
				report "punpckldq: Failed." severity error;
			end if;
			wait for period;

			wait;
		end process;  
		
	end beh;