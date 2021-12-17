--VHDL 1076-2008 
--ALU

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port( 		  
	src:  in std_logic_vector(63 downto 0);	--source register
	dest: in std_logic_vector(63 downto 0);	--destination register
	ins:  in std_logic_vector(23 downto 0);	--instruction to execute
	
	res: out std_logic_vector(63 downto 0)  --result
	);
end alu;  

architecture beh of alu is	

--SATURATED ARITHMETIC FUNCTIONS:
--Saturated addition of two signed bytes
function add_sb_saturated(s1, s2: signed(7 downto 0)) return signed is
variable result: signed(7 downto 0);
begin			  
	result := s1 + s2;	 
	
	if(s1(7) = '0' and s2(7) = '0' and result(7) = '1') then
		result := X"7F";
	end if;
	
	if(s1(7) = '1' and s2(7) = '1' and result(7) = '0') then
		result := X"80";
	end if;
	
	return result;
end add_sb_saturated;

--Saturated addition of two signed words (16 bits)
function add_sw_saturated(s1, s2: signed(15 downto 0)) return signed is
variable result: signed(15 downto 0);
begin			  
	result := s1 + s2;	 
	
	if(s1(15) = '0' and s2(15) = '0' and result(15) = '1') then
		result := X"7FFF";
	end if;
	
	if(s1(15) = '1' and s2(15) = '1' and result(15) = '0') then
		result := X"8000";
	end if;
	
	return result;
end add_sw_saturated;

--Saturated addition of two unsigned bytes
function add_usb_saturated(u1, u2: unsigned(7 downto 0)) return unsigned is
variable result: unsigned(7 downto 0);
begin			  
	result := u1 + u2;	 
	
	if(result < u1 or result < u2) then	 
		result := X"FF";
		end if;
	
	return result;
end add_usb_saturated;

--Saturated addition of two unsigned words (16 bits)
function add_usw_saturated(u1, u2: unsigned(15 downto 0)) return unsigned is
variable result: unsigned(15 downto 0);
begin			  
	result := u1 + u2;
	
	if(result < u1 or result < u2) then	 
		result := X"FFFF";
		end if;
	
	return result;
end add_usw_saturated;

--SATURATED PACKING FUNCTIONS:
--Convert double-word to word by saturation
function pack_dw_signed_saturated(d: signed(31 downto 0)) return signed is
variable result: signed(15 downto 0);
begin			  
	if(d < -32768) then
		result := X"8000";
	elsif(d > 32767) then
		result := X"7FFF";
	else 
		result := d(15 downto 0);
	end if;
	return result;
end pack_dw_signed_saturated;


--INSTRUCTIONS:
--pldi
impure function pldi return std_logic_vector is	
variable index:  integer := to_integer(unsigned(ins(8 downto 6)));	 
variable imm:    std_logic_vector(63 downto 0) := (others => '0');
variable result: std_logic_vector(63 downto 0) := dest;	
begin	 
	imm(7 downto 0) := ins(16 downto 9);	
	imm := imm sll (index * 8);
	result := result and ((X"FF_FF_FF_FF_FF_FF_FF_00") rol (index * 8));  
	result := result or imm;
	return result;
end pldi;

--psllw
impure function psllw return std_logic_vector is		 
variable shamt:  integer := to_integer(unsigned(ins(16 downto 9)));
variable result: std_logic_vector(63 downto 0) := dest;	
begin	 
	result(15 downto 0)  := result(15 downto 0)  sll shamt;
	result(31 downto 16) := result(31 downto 16) sll shamt;
	result(47 downto 32) := result(47 downto 32) sll shamt;
	result(63 downto 48) := result(63 downto 48) sll shamt;
	return result;
end psllw;	

--pslld
impure function pslld return std_logic_vector is		 
variable shamt:  integer := to_integer(unsigned(ins(16 downto 9)));
variable result: std_logic_vector(63 downto 0) := dest;	
begin	 
	result(31 downto 0)  := result(31 downto 0)  sll shamt;
	result(63 downto 32) := result(63 downto 32) sll shamt;
	return result;
end pslld;	

--psllq
impure function psllq return std_logic_vector is		 
variable shamt:  integer := to_integer(unsigned(ins(16 downto 9)));
begin	 
	return dest sll shamt;
end psllq;		

--psrlw
impure function psrlw return std_logic_vector is		 
variable shamt:  integer := to_integer(unsigned(ins(16 downto 9)));
variable result: std_logic_vector(63 downto 0) := dest;	
begin	 
	result(15 downto 0)  := result(15 downto 0)  srl shamt;
	result(31 downto 16) := result(31 downto 16) srl shamt;
	result(47 downto 32) := result(47 downto 32) srl shamt;
	result(63 downto 48) := result(63 downto 48) srl shamt;
	return result;
end psrlw;	

--psrld
impure function psrld return std_logic_vector is		 
variable shamt:  integer := to_integer(unsigned(ins(16 downto 9)));
variable result: std_logic_vector(63 downto 0) := dest;	
begin	 
	result(31 downto 0)  := result(31 downto 0)  srl shamt;
	result(63 downto 32) := result(63 downto 32) srl shamt;
	return result;
end psrld;	

--psrlq
impure function psrlq return std_logic_vector is		 
variable shamt:  integer := to_integer(unsigned(ins(16 downto 9)));
begin	 
	return dest srl shamt;
end psrlq;	 

--paddb
impure function paddb return std_logic_vector is		 
variable result: unsigned(63 downto 0) := (others=>'0');
variable srcu:   unsigned(63 downto 0) := unsigned(src);
variable destu:  unsigned(63 downto 0) := unsigned(dest);
begin	 
	result(7 downto 0)   := srcu(7 downto 0) + destu(7 downto 0);
	result(15 downto 8)  := srcu(15 downto 8) + destu(15 downto 8);
	result(23 downto 16) := srcu(23 downto 16) + destu(23 downto 16);
	result(31 downto 24) := srcu(31 downto 24) + destu(31 downto 24);
	result(39 downto 32) := srcu(39 downto 32) + destu(39 downto 32);
	result(47 downto 40) := srcu(47 downto 40) + destu(47 downto 40);
	result(55 downto 48) := srcu(55 downto 48) + destu(55 downto 48);
	result(63 downto 56) := srcu(63 downto 56) + destu(63 downto 56);
	return std_logic_vector(result);
end paddb;	

--paddsb
impure function paddsb return std_logic_vector is		 
variable result: signed(63 downto 0) := (others=>'0');
variable srcs:   signed(63 downto 0) := signed(src);
variable dests:  signed(63 downto 0) := signed(dest);
begin	 
	result(7 downto 0)   := add_sb_saturated(srcs(7 downto 0), dests(7 downto 0));
	result(15 downto 8)  := add_sb_saturated(srcs(15 downto 8), dests(15 downto 8));
	result(23 downto 16) := add_sb_saturated(srcs(23 downto 16), dests(23 downto 16));
	result(31 downto 24) := add_sb_saturated(srcs(31 downto 24), dests(31 downto 24));
	result(39 downto 32) := add_sb_saturated(srcs(39 downto 32), dests(39 downto 32));
	result(47 downto 40) := add_sb_saturated(srcs(47 downto 40), dests(47 downto 40));
	result(55 downto 48) := add_sb_saturated(srcs(55 downto 48), dests(55 downto 48));
	result(63 downto 56) := add_sb_saturated(srcs(63 downto 56), dests(63 downto 56));
	return std_logic_vector(result);
end paddsb;	 

--paddusb
impure function paddusb return std_logic_vector is		 
variable result: unsigned(63 downto 0) := (others=>'0');
variable srcs:   unsigned(63 downto 0) := unsigned(src);
variable dests:  unsigned(63 downto 0) := unsigned(dest);
begin	 
	result(7 downto 0)   := add_usb_saturated(srcs(7 downto 0), dests(7 downto 0));
	result(15 downto 8)  := add_usb_saturated(srcs(15 downto 8), dests(15 downto 8));
	result(23 downto 16) := add_usb_saturated(srcs(23 downto 16), dests(23 downto 16));
	result(31 downto 24) := add_usb_saturated(srcs(31 downto 24), dests(31 downto 24));
	result(39 downto 32) := add_usb_saturated(srcs(39 downto 32), dests(39 downto 32));
	result(47 downto 40) := add_usb_saturated(srcs(47 downto 40), dests(47 downto 40));
	result(55 downto 48) := add_usb_saturated(srcs(55 downto 48), dests(55 downto 48));
	result(63 downto 56) := add_usb_saturated(srcs(63 downto 56), dests(63 downto 56));
	return std_logic_vector(result);
end paddusb;		   

--paddw
impure function paddw return std_logic_vector is		 
variable result: unsigned(63 downto 0) := (others=>'0');
variable srcu:   unsigned(63 downto 0) := unsigned(src);
variable destu:  unsigned(63 downto 0) := unsigned(dest);
begin	 
	result(15 downto 0)  := srcu(15 downto 0)  + destu(15 downto 0);
	result(31 downto 16) := srcu(31 downto 16) + destu(31 downto 16);
	result(47 downto 32) := srcu(47 downto 32) + destu(47 downto 32);
	result(63 downto 48) := srcu(63 downto 48) + destu(63 downto 48);
	return std_logic_vector(result);
end paddw;	

--paddsw
impure function paddsw return std_logic_vector is		 
variable result: signed(63 downto 0) := (others=>'0');
variable srcs:   signed(63 downto 0) := signed(src);
variable dests:  signed(63 downto 0) := signed(dest);
begin	 
	result(15 downto 0)  := add_sw_saturated(srcs(15 downto 0), dests(15 downto 0));
	result(31 downto 16) := add_sw_saturated(srcs(31 downto 16), dests(31 downto 16));
	result(47 downto 32) := add_sw_saturated(srcs(47 downto 32), dests(47 downto 32));
	result(63 downto 48) := add_sw_saturated(srcs(63 downto 48), dests(63 downto 48));
	return std_logic_vector(result);
end paddsw;

--paddusw
impure function paddusw return std_logic_vector is		 
variable result: unsigned(63 downto 0) := (others=>'0');
variable srcu:   unsigned(63 downto 0) := unsigned(src);
variable destu:  unsigned(63 downto 0) := unsigned(dest);
begin	 
	result(15 downto 0)  := add_usw_saturated(srcu(15 downto 0), destu(15 downto 0));
	result(31 downto 16) := add_usw_saturated(srcu(31 downto 16), destu(31 downto 16));
	result(47 downto 32) := add_usw_saturated(srcu(47 downto 32), destu(47 downto 32));
	result(63 downto 48) := add_usw_saturated(srcu(63 downto 48), destu(63 downto 48));
	return std_logic_vector(result);
end paddusw;

--paddd
impure function paddd return std_logic_vector is		 
variable result: unsigned(63 downto 0) := (others=>'0');
variable srcu:   unsigned(63 downto 0) := unsigned(src);
variable destu:  unsigned(63 downto 0) := unsigned(dest);
begin	 
	result(31 downto 0)  := srcu(31 downto 0) + destu(31 downto 0);
	result(63 downto 32) := srcu(63 downto 32) + destu(63 downto 32);
	return std_logic_vector(result);
end paddd; 

--packssdw
impure function packssdw return std_logic_vector is		 
variable result: std_logic_vector(63 downto 0) := (others=>'0');
variable word3: signed(15 downto 0) := pack_dw_signed_saturated(signed(src(63 downto 32)));
variable word2: signed(15 downto 0) := pack_dw_signed_saturated(signed(src(31 downto 0)));
variable word1: signed(15 downto 0) := pack_dw_signed_saturated(signed(dest(63 downto 32)));
variable word0: signed(15 downto 0) := pack_dw_signed_saturated(signed(dest(31 downto 0)));
begin	 	  
	result(15 downto 0)  := std_logic_vector(word0);
	result(31 downto 16) := std_logic_vector(word1);
	result(47 downto 32) := std_logic_vector(word2);
	result(63 downto 48) := std_logic_vector(word3);
	return result;
end packssdw;

--Main ALU operation
begin	
	
	main: process(src, dest, ins)		
	begin 
		
		case ins(23 downto 17) is
			when "0000000" => res <= pldi;
			when "0000001" => res <= src and X"00_00_00_00_FF_FF_FF_FF"; --movd
			when "0000010" => res <= src;          --movq 
			when "0000011" => res <= src and dest; --pand
			when "0000100" => res <= src or dest;	--por
			when "0000101" => res <= src nand dest;--pandn
			when "0000110" => res <= src xor dest;	--pxor
			when "0000111" => res <= psllw;
			when "0001000" => res <= pslld;
			when "0001001" => res <= psllq;
			when "0001010" => res <= psrlw;
			when "0001011" => res <= psrld;
			when "0001100" => res <= psrlq; 
			when "0001101" => res <= paddb;
			when "0001110" => res <= paddsb;
			when "0001111" => res <= paddusb;	
			when "0010000" => res <= paddw;	
			when "0010001" => res <= paddsw;
			when "0010010" => res <= paddusw;	
			when "0010011" => res <= paddd;	
			when "0010100" => res <= packssdw;
			when others => res <= X"XXXXXXXXXXXXXXXX";			
		end case;  
		
	end process;

end beh;
	