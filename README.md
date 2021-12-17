## 3-Byte Instruction Format
| **23:17** Opcode | **16:9** Immediate Value | **7:5** Load Index |   **5:3** Source Register    | **2:0** Destination Register |
|------------------|--------------------------|--------------------|------------------------------|------------------------------|
## Instruction List
Complete reference can be found here: https://www.csie.ntu.edu.tw/~cyy/courses/assembly/docs/ch11_MMX.pdf
### Load Immediate
| Syntax             | Description                                                          | Opcode  |
|--------------------|----------------------------------------------------------------------|---------|
| **pldi** imm8, idx, dest | Load 8-bit immediate *imm8* into the 8-bit field of register *dest* indexed by *idx* | 0000000 |
### Data Movement
| Syntax | Description | Opcode  |
|--------|-------------|---------|
|   **movd** src, dest    |   Copies lower double-word of *src* to lower double-word of *dest*, and clears the upper double-word of *dest*          |    0000001     |
|   **movq** src, dest     |    Copies 64-bit value of *src* to *dest*         |     0000010    |
### Boolean Logic
| Syntax | Description | Opcode  |
|--------|-------------|---------|
|   **pand** src, dest    |   Logical AND of two 64-bit values          |  0000011       |
|   **por** src, dest     |   Logical OR of two 64-bit values          |    0000100     |
|    **pandn** src, dest    |   Logical NAND of two 64-bit values          |   0000101      |
|    **pxor** src, dest    |   Logical XOR of two 64-bit values          |    0000110     |
### Shifting
| Syntax | Description | Opcode  |
|--------|-------------|---------|
|   **psllw**  imm8, reg   |   Logical left shift 16-bit words in *reg* by amount specified in *imm8*          |   0000111      |
|   **pslld**  imm8, reg     |     Logical left shift 32-bit double-words in *reg* by amount specified in *imm8*        |   0001000      |
|   **psllq**  imm8, reg     |   Logical left shift value in *reg* by amount specified in *imm8*          |   0001001       |
|   **psrlw**  imm8, reg    |     Logical right shift 16-bit words in *reg* by amount specified in *imm8*        |   0001010       |
|   **psrld**  imm8, reg     |   Logical right shift 32-bit double-words in *reg* by amount specified in *imm8*          |   0001011      |
|   **psrlq**  imm8, reg     |     Logical right shift value in *reg* by amount specified in *imm8*        |   0001100       |
###  Arithmetic
| Syntax | Description | Opcode  |
|--------|-------------|---------|
|   **paddb** src, dest     |    Unsigned addition of bytes in registers *src* and *dest*         |   0001101      |
|   **paddsb** src, dest     |     Saturated addition of signed bytes in *src* and *dest*        |   0001110     |
|   **paddusb** src, dest     |    Saturated addition of unsigned bytes in *src* and *dest*         |    0001111     |
|   **paddw** src, dest     |     Unsigned addition of 16-bit words in registers *src* and *dest*        |  0010000       |
|   **paddsw** src, dest     |     Saturated addition of 16-bit signed words in *src* and *dest*        |   0010001      |
|   **paddusw** src, dest     |     Saturated addition of 16-bit unsigned words in *src* and *dest*        |    0010010     |
|   **paddd** src, dest     |    Unsigned addition of 32-bit double-words in registers *src* and *dest*         |    0010011     |
### Data Packing
| Syntax | Description | Opcode  |
|--------|-------------|---------|
|   **packssdw** src, dest    |   Convert double-words to words by signed saturation       |    0010100     |
|   **packsswb** src, dest    |   Convert words to bytes by signed saturation       |    0010101     |
|   **packusdw** src, dest   |    Convert double-words to words by unsigned saturation      |    0010110     |
|   **packuswb** src, dest   |    Convert words to bytes by unsigned saturation      |    0010111     |
|   **punpcklbw** src, dest   |   Unpack the lower four bytes from *src* and *dest* and store them as interleaved bytes in *dest*.       |   0011000      |
|   **punpcklwd** src, dest   |    Unpack the lower two words from *src* and *dest* and store them as interleaved words in *dest*.      |   0011010      |
|   **punpckldq** src, dest   |    Unpack the bottom double-words of two registers and store them in *dest*.      |   0011001      |
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTcxMTc0MTk3Miw2NTU1MDMyMzUsMzA4Nj
cyNTIsLTIwMjk4NDU4NTMsLTEzMTE5Mjc1MDMsLTEwMDkzNjgy
MzksMjc4MzIwMzc2LDIxNDI5MzM3NzYsNzQ0MzIyMjkxLDI2OT
c3NDkwMiwtMjA0NjgyMTc1OSwtMTU0MjEwNTIzMywxNDY4NTg0
NTQxLDE1MTY4NDA1MiwtODY0MTk4Mzc1LC0xNTA1MTAyNjI3LC
0xNTQ1Nzk1OTgxLDIxMjk0NjU2NTVdfQ==
-->