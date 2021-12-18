#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include "assembler.h"

#define BUFF_SIZE 100

unsigned int line_num = 1;
std::map<std::string, char> register_map = init_register_map();
std::map<std::string, uint32_t> ins_map  = init_instruction_map();
std::map<std::string, INS_TYPE> ins_type_map = init_instype_map();

//FUNCTION DECLARATIONS
uint32_t parse_instruction(char buffer[BUFF_SIZE]);  //parse a line of input (one instruction)
uint32_t get_register(std::string token);            //parse individual tokens
uint32_t get_load_index(std::string token);
uint32_t get_16bit_immediate(std::string token);
INS_TYPE get_type(std::string ins_name);            //get type of instruction based on name
std::vector<std::string> split_string(std::string s, std::string delim);  //split a string 
void write_three_bytes(uint32_t data, std::ofstream& of);                  //write 'data' to output stream as four bytes

int main(int argc, char* argv[]) {

	//CHECK ARGUMENTS
	if (argc < 2 || argc > 3) {
		std::cerr << "ERROR: Invalid arguments. Specify one input file, and optionally an output file.";
		exit(1);
	}

	//DECLARE VARIABLES
	char buffer[BUFF_SIZE];
	std::ifstream in_stream;
	std::ofstream out_stream;

	//SET UP FILE STREAMS
	in_stream = std::ifstream(argv[1], std::ifstream::in);
	if (in_stream.fail()) {
		std::cerr << "ERROR: Could not open input file.";
		exit(1);
	}

	if (argc == 3)
		out_stream = std::ofstream(argv[2], std::ios::binary | std::ios::out);
	else
		out_stream = std::ofstream("assembler_output.bin", std::ios::binary | std::ios::out);
	if (out_stream.fail()) {
		std::cerr << "ERROR: Could not open output file.";
		exit(1);
	}

	//MAIN LOOP
	while (!in_stream.eof()) {  

		in_stream.getline(buffer, BUFF_SIZE);  //read next line

		if (in_stream.fail()) {  //no characters read
			in_stream.clear(in_stream.failbit);
			continue;
		}

		uint32_t ins_code = parse_instruction(buffer);  //get the instruction encoding
		write_three_bytes(ins_code, out_stream);         //write to output file
		line_num++;

	}//end main loop

	in_stream.close();
	out_stream.close();
}

//parse a line of input (one instruction)
uint32_t parse_instruction(char buffer[BUFF_SIZE]) {
	std::string line = buffer;
	std::vector<std::string> tokens = split_string(line, " ");

	if (ins_type_map.find(tokens[0]) == ins_type_map.end()) {
		std::cerr << "ERROR LINE " << line_num << ": Invalid instruction.";
		exit(1);
	}

	INS_TYPE type = ins_type_map[tokens[0]];
	uint32_t ins_code = ins_map[tokens[0]];
	uint32_t src, dest, load_index, immediate;

	switch (type) {

	}

	return ins_code;
}

//get the 5-bit code for a register from its string token
uint32_t get_register(std::string token) {
	if (register_map.find(token) == register_map.end()) {
		std::cerr << "ERROR LINE " << line_num << ": Register name invalid.";
		exit(1);
	}
	return register_map[token];
}

//get 3-bit code for load index from string token
uint32_t get_load_index(std::string token) {
	int index = stoi(token);
	if (index < 0 || index > 7) {
		std::cerr << "ERROR LINE " << line_num << ": Invalid load index; must be between 0 and 7.";
		exit(1);
	}
	return index;
}

//get 16-bit immediate value from string token
uint32_t get_16bit_immediate(std::string token){
	uint32_t imm = stoi(token);
	if (imm > UINT8_MAX) {
		std::cerr << "ERROR LINE " << line_num << ": Immediate value too large.";
		exit(1);
	}
	return imm;
}

//split a string into substrigs separated by the delimeter string
std::vector<std::string> split_string(std::string s, std::string delim) {
	std::vector<std::string> substrings;
	s = s + delim;
	size_t start_pos = 0;
	size_t end_pos;
	while ((end_pos = s.find(delim, start_pos)) != std::string::npos) {
		substrings.push_back(s.substr(start_pos, end_pos - start_pos));
		start_pos = end_pos + delim.length();
	}

	return substrings;
}

void write_three_bytes(uint32_t data, std::ofstream& of) {
	char bytes[3];
	bytes[2] = (char)(data >> 16);
	bytes[1] = (char)(data >> 8);
	bytes[0] = (char)data;

	of << bytes[2] << bytes[1] << bytes[0];
}