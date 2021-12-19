#include <string>
#include <map>
#include <cstdint>

/*==================================SYNTAX RULES=====================================
* Each token within an instruction (instruction name, register name, or immediate value) must be separated by a space,
* and each instruction must be on a separate line
*
* IMMEDIATES: Any immediate (including load index) must be specified in decimal
*
* REGISTERS: Registers can be specified by register name (mm0, mm1, etc.) or by the decimal value of the register (0, 1, etc.)
*
* INSTRUCTION FORMATS are defined by the enum INS_TYPE as follows:
* PLDI:         pldi imm8 idx dest          ex. pldi 1 5 mm0
* TWO_REG:      {in_name} src dest          ex. movq mm0 mm7
* IMM_REG:      {in_name} imm8 reg          ex. psrlq 40 mm7
===================================================================================*/
enum class INS_TYPE {
	PLDI,
	TWO_REG,
	IMM_REG
};

//initializes a map that maps a register name to the corresponding bit pattern
std::map<std::string, char> init_register_map() {
	std::map<std::string, char> register_map;
	register_map["mm0"] = register_map["0"] = 0;
	register_map["mm1"] = register_map["1"] = 1;
	register_map["mm2"] = register_map["2"] = 2;
	register_map["mm3"] = register_map["3"] = 3;
	register_map["mm4"] = register_map["4"] = 4;
	register_map["mm5"] = register_map["5"] = 5;
	register_map["mm6"] = register_map["6"] = 6;
	register_map["mm7"] = register_map["7"] = 7;
	return register_map;
}

//initializes a map that maps an instruction name to the corresponding 32-bit pattern 
//only the opcode field is filled in. other fields like registers, immediates etc. are 0
std::map<std::string, uint32_t> init_instruction_map() {
	std::map<std::string, uint32_t> ins_map;
	ins_map["pldi"]      = 0b00000000'0000000'00000000'000'000'000;
	ins_map["movd"]      = 0b00000000'0000001'00000000'000'000'000;
	ins_map["movq"]      = 0b00000000'0000010'00000000'000'000'000;
	ins_map["pand"]      = 0b00000000'0000011'00000000'000'000'000;
	ins_map["por"]       = 0b00000000'0000100'00000000'000'000'000;
	ins_map["pandn"]     = 0b00000000'0000101'00000000'000'000'000;
	ins_map["pxor"]      = 0b00000000'0000110'00000000'000'000'000;
	ins_map["psllw"]     = 0b00000000'0000111'00000000'000'000'000;
	ins_map["pslld"]     = 0b00000000'0001000'00000000'000'000'000;
	ins_map["psllq"]     = 0b00000000'0001001'00000000'000'000'000;
	ins_map["psrlw"]     = 0b00000000'0001010'00000000'000'000'000;
	ins_map["psrld"]     = 0b00000000'0001011'00000000'000'000'000;
	ins_map["psrlq"]     = 0b00000000'0001100'00000000'000'000'000;
	ins_map["paddb"]     = 0b00000000'0001101'00000000'000'000'000;
	ins_map["paddsb"]    = 0b00000000'0001110'00000000'000'000'000;
	ins_map["paddusb"]   = 0b00000000'0001111'00000000'000'000'000;
	ins_map["paddw"]     = 0b00000000'0010000'00000000'000'000'000;
	ins_map["paddsw"]    = 0b00000000'0010001'00000000'000'000'000;
	ins_map["paddusw"]   = 0b00000000'0010010'00000000'000'000'000;
	ins_map["paddd"]     = 0b00000000'0010011'00000000'000'000'000;
	ins_map["packssdw"]  = 0b00000000'0010100'00000000'000'000'000;
	ins_map["packsswb"]  = 0b00000000'0010101'00000000'000'000'000;
	ins_map["packusdw"]  = 0b00000000'0010110'00000000'000'000'000;
	ins_map["packuswb"]  = 0b00000000'0010111'00000000'000'000'000;
	ins_map["punpcklbw"] = 0b00000000'0011000'00000000'000'000'000;
	ins_map["punpcklwd"] = 0b00000000'0011001'00000000'000'000'000;
	ins_map["punpckldq"] = 0b00000000'0011010'00000000'000'000'000;
	return ins_map;
}

//initializes a map that maps an instruction name to the corresponding instruction type
std::map<std::string, INS_TYPE> init_instype_map() {
	std::map<std::string, INS_TYPE> ins_map;
	ins_map["pldi"]      = INS_TYPE::PLDI;
	ins_map["movd"]      = INS_TYPE::TWO_REG;
	ins_map["movq"]      = INS_TYPE::TWO_REG;
	ins_map["pand"]      = INS_TYPE::TWO_REG;
	ins_map["por"]       = INS_TYPE::TWO_REG;
	ins_map["pandn"]     = INS_TYPE::TWO_REG;
	ins_map["pxor"]      = INS_TYPE::TWO_REG;
	ins_map["psllw"]     = INS_TYPE::IMM_REG;
	ins_map["pslld"]     = INS_TYPE::IMM_REG;
	ins_map["psllq"]     = INS_TYPE::IMM_REG;
	ins_map["psrlw"]     = INS_TYPE::IMM_REG;
	ins_map["psrld"]     = INS_TYPE::IMM_REG;
	ins_map["psrlq"]     = INS_TYPE::IMM_REG;
	ins_map["paddb"]     = INS_TYPE::TWO_REG;
	ins_map["paddsb"]    = INS_TYPE::TWO_REG;
	ins_map["paddusb"]   = INS_TYPE::TWO_REG;
	ins_map["paddw"]     = INS_TYPE::TWO_REG;
	ins_map["paddsw"]    = INS_TYPE::TWO_REG;
	ins_map["paddusw"]   = INS_TYPE::TWO_REG;
	ins_map["paddd"]     = INS_TYPE::TWO_REG;
	ins_map["packssdw"]  = INS_TYPE::TWO_REG;
	ins_map["packsswb"]  = INS_TYPE::TWO_REG;
	ins_map["packusdw"]  = INS_TYPE::TWO_REG;
	ins_map["packuswb"]  = INS_TYPE::TWO_REG;
	ins_map["punpcklbw"] = INS_TYPE::TWO_REG;
	ins_map["punpcklwd"] = INS_TYPE::TWO_REG;
	ins_map["punpckldq"] = INS_TYPE::TWO_REG;
	return ins_map;
}