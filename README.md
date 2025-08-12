# RISC V Overview
RISC-V is an open-source processor architecture designed to be simple, flexible, and free to use. It follows the RISC (Reduced Instruction Set Computing) model, using a small set of instructions for efficient performance. Created at the University of California, Berkeley, RISC-V can be used in everything from small devices like sensors to large systems like servers. Its open nature means anyone can study, modify, or build with it without licensing fees. This makes RISC-V popular for education, research, and product development, encouraging innovation in hardware and software design.

<p align="center"> <img src="https://github.com/Aatib-cpu/RISC-V-Architecture/blob/main/RISC_families.png" alt="logo" style="width: 70%;">

# RV32I ISA
RISC-V has <mark>**four core instruction formats: R, I, S, & U**</mark>. Additionally, there are <mark>**two sub-formats: SB & UJ**</mark>, commonly referred to as B-type and J-type, respectively. They are named this way because the B-type shares the same instruction format as the S-type, and the J-type shares the same format as the U-type. Please refer this for complete understanding of RV32I ISA and other attributes:- 
<a href="https://github.com/Aatib-cpu/RISC-V-Architecture/blob/main/rvalp.pdf" style="background-color: orange; padding: 2px 4px; text-decoration: none; color: white; font-weight: bold;">
RISC V Official Manual
</a>

This image shows the instuction encoding of RV32I:

<p align="center"> <img src="https://github.com/Aatib-cpu/RISC-V-Architecture/blob/main/RISC_base_ISA.png" alt="logo" style="width: 70%;">

In each instruction format, the 32-bit instruction is divided into fields that define the operation and the operands. The <mark>**opcode**, **funct3**, and **funct7**</mark> fields determine the operation to be executed, while the remaining bits specify the operands involved. 

<p align="center"> <img src="https://github.com/Aatib-cpu/RISC-V-Architecture/blob/main/RISCV_37_instructions_Encoding.png" alt="logo" style="width: 80%;">

In RV32I, there are **32 general-purpose registers**, each 32 bits wide, named **x0** to **x31**. Among these, special-purpose registers exist—x0 is hardwired to zero and cannot be modified, while the program counter (PC) holds the address of the next instruction to be executed. Following tabels describe all registers with their aliases based on their conventional uses.
>***NOTE:*** All signed operation in RV32I are done in 2's compliment form. So all value in registers and memories are in 2's complement.

<p align="center"> <img src="https://github.com/Aatib-cpu/RISC-V-Architecture/blob/main/Registers.png" alt="logo" style="width: 50%;">

RV32I includes a total of 47 instructions, but a core set of 37 instructions (excluding NOP, ECALL, EBREAK, and other synchronization or pseudo-instructions) is sufficient to perform all fundamental integer operations. Here are the 37 instruction encoding with assembly level instruction.

<p align="center"> <img src="https://github.com/Aatib-cpu/RISC-V-Architecture/blob/main/RISCV_37_instructions.png" alt="logo" style="width: 80%;">

Except for R-type instructions, all other instruction formats include one operand embedded within the instruction itself, which is used to obtain an immediate value.
>_NOTE:_ To form a 32-bit immediate, different alignment and extension techniques are applied depending on the instruction type. For signed operations, the immediate is sign-extended using the most significant bit (MSB), while for unsigned operations, it is zero-extended.

Here are the alignments to obtain the 32 bit immediate from instruction in different instruction format like I type, I type shift, S type, U type, J type and B type. Remember the "sign or zero extension" is done on the basis of instruction opcode.

<p align="center"> <img src="https://github.com/Aatib-cpu/RISC-V-Architecture/blob/main/imm_i.png" alt="logo" style="width: 80%;">
  
<p align="center"> <img src="https://github.com/Aatib-cpu/RISC-V-Architecture/blob/main/imm_i_shift.png" alt="logo" style="width: 80%;">

<p align="center"> <img src="https://github.com/Aatib-cpu/RISC-V-Architecture/blob/main/imm_s.png" alt="logo" style="width: 80%;">

<p align="center"> <img src="https://github.com/Aatib-cpu/RISC-V-Architecture/blob/main/imm_u.png" alt="logo" style="width: 80%;">
   
<p align="center"> <img src="https://github.com/Aatib-cpu/RISC-V-Architecture/blob/main/imm_j.png" alt="logo" style="width: 80%;">

<p align="center"> <img src="https://github.com/Aatib-cpu/RISC-V-Architecture/blob/main/imm_b.png" alt="logo" style="width: 80%;">

# Our Implementation of RV32I
Our aim was to design an RV32I processor for error-prone applications, so we incorporated several new blocks to address various hazards in existing RISC V architecture.  
**Pipeline Management:**

**Fowarding Unit:**

## Architecture
<img src="https://github.com/Aatib-cpu/RISC-V-Architecture/blob/main/RISC_V_Architecture.excalidraw.png" alt="logo" style="width: 100%;">

Feature list:
- All 37 instruction of R,I,J,S,B,U Format are implemented
- All cases of ”Data Dependency” is checked and Forwarding unit is optimized to address all ”Data Hazard”
- Bubble insertion technique is used to address ”Control Hazard”
- Minimum frequency obtained is 85.84 MHz with 4897 LUT, 4543 FF and 130 IO
