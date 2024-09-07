`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2024 03:22:22 PM
// Design Name: 
// Module Name: RISC_Datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RISC_Datapath(
input Clk, Reset,                           //Clock and Reset Signal
output [31:0] Alu_Out,
output [31:0] Mem_Out,
output [31:0] Data_Write_Back_Ot,
output [31:0] rd_WB_0t
);
wire Do_Stall; //For Data Hazard from memory
wire [1:0] MUX_IF_PM;
wire Is_Branch_Taken; //For Control Hazard
wire [31:0] Address_EX;                //Branch Address from ALU
wire [31:0] Instruction_Fetch_IF;         //32 bit Instruction, fetched from Instruction Memory
wire [31:0] Instruction_Register_ID;    //32 bit Instruction, from Decode Stage
wire [31:0] PC_IF;   //IF stage PC Register
wire [31:0] PC_ID;   //ID stage PC Register
wire [4:0] rs1_ID; //Address of rs1
wire [4:0] rs2_ID; //Address of rs2
wire [4:0] rd_ID;   //Address of rd  
wire [6:0] Opcode;
wire [2:0] Func3_ID;
wire Read_Enable_1;        //Read Enable for rs1
wire Read_Enable_2;        //Read Enable for rs2
wire Write_Enable_ID;         //Write Enable for rd
wire Write_Enable_WB;
wire [31:0] Data_Write_Back;       //Data to be written in rd
wire [4:0] Alu_Cntrl_ID; //ALU Control
wire [31:0] Operand1_ACU_ID; //Operand 1 to Address ALU
wire [31:0] Operand2_ACU_ID; //Operand 2 to Data ALU
wire [31:0] Operand1_DEU_ID; //Operand 1 to Data ALU
wire [31:0] Operand2_DEU_ID; //Operand 2 to Address ALU 
wire [6:0] Immediate_Format_ID;
wire [4:0] rd_WB;
wire Rs1_Valid_ID;
wire Rs2_Valid_ID;
wire [4:0] rs1_ID_PM;
wire [4:0] rs2_ID_PM;
wire [4:0] rd_ID_PM;   //Address of rd
wire [2:0] Func3_ID_PM;
wire I_Type_Load_EX; 
wire S_Type_EX;
wire [31:0] Alu_Out_EX;
wire [2:0] Func3_EX;
wire [4:0] rd_EX;   //Address of rd
wire Write_Enable_EX;
wire MUX_ID_PM;
wire B_Type_EX, U_Type_LUI_EX, U_Type_AUIPC_EX, J_Type_EX, I_Type_JAL_R_EX;
wire [31:0] PC_EX;
wire [31:0] Operand1_ACU_EX,Operand2_ACU_EX,Operand1_DEU_EX,Operand2_DEU_EX;
wire [4:0] Alu_Cntrl_EX; //ALU Control
wire [4:0] rs1_EX;
wire [4:0] rs2_EX;
wire Rs1_Valid_EX;
wire Rs2_Valid_EX;
wire Write_Enable_MEM;         //rd_Valid execute
wire [4:0] rd_MEM;         //rd after execute
wire [31:0] Alu_Out_MEM;       //Alu from execute
wire Write_Back_Control_WB;            //Load Type format after stage 4 
wire [31:0] Loaded_Data_WB;    //Load from memory
wire [31:0] Alu_Out_WB;       //Alu after stage 4
wire [31:0] Operand1_ACU_EX_Fwd;
wire [31:0] Operand1_DEU_EX_Fwd;
wire [31:0] Operand2_DEU_EX_Fwd;
wire I_Type_Load_MEM;
wire S_Type_MEM;
wire [31:0] PC_MEM;
wire [2:0] Func3_MEM;
wire [31:0] Address_MEM; // Mem_Address_Reg
wire [31:0] Loaded_Data_MEM;
wire Mem_Enable;
wire [31:0] PC_WB;

Stage_1 F(Clk,Reset,Do_Stall,Is_Branch_Taken,MUX_IF_PM,Address_EX,Instruction_Register_ID,PC_IF,Instruction_Fetch_IF);

IF_ID_Pipeline FD(Clk, Reset,Instruction_Fetch_IF,PC_IF,Instruction_Register_ID,PC_ID,rs1_ID,rs2_ID,rd_ID,Opcode,Func3_ID);

Pipeline_Management PM(rs1_ID,rs2_ID,Rs1_Valid_ID,Rs2_Valid_ID,rd_EX,Write_Enable_EX,I_Type_Load_EX,Is_Branch_Taken,Do_Stall,MUX_IF_PM,MUX_ID_PM);

assign Read_Enable_1=1'b1;assign Read_Enable_2=1'b1;
Stage_2 D(Clk,Reset,Read_Enable_1,Read_Enable_2,Write_Enable_WB,PC_ID,Data_Write_Back,rs1_ID,rs2_ID,rd_ID,rd_WB,
Instruction_Register_ID,Func3_ID,MUX_ID_PM,Operand1_ACU_ID,Operand2_ACU_ID,Operand1_DEU_ID,Operand2_DEU_ID,Alu_Cntrl_ID,rs1_ID_PM,rs2_ID_PM,
Func3_ID_PM,Immediate_Format_ID,rd_ID_PM,Rs1_Valid_ID,Rs2_Valid_ID,Write_Enable_ID);

ID_EX_Pipeline DEX(Clk,Reset,PC_ID,Operand1_ACU_ID,Operand2_ACU_ID,Operand1_DEU_ID,Operand2_DEU_ID,Alu_Cntrl_ID,rs1_ID_PM,rs2_ID_PM,Func3_ID_PM,
Immediate_Format_ID,rd_ID_PM,Rs1_Valid_ID,Rs2_Valid_ID,Write_Enable_ID,I_Type_Load_EX,S_Type_EX,B_Type_EX,U_Type_LUI_EX,U_Type_AUIPC_EX,J_Type_EX,
I_Type_JAL_R_EX,PC_EX,Operand1_ACU_EX,Operand2_ACU_EX,Operand1_DEU_EX,Operand2_DEU_EX,Alu_Cntrl_EX,rs1_EX,rs2_EX,Func3_EX,rd_EX,Rs1_Valid_EX,Rs2_Valid_EX,
Write_Enable_EX);

Forwarding_Unit FU(Operand1_ACU_EX,Operand1_DEU_EX,Operand2_DEU_EX,Rs1_Valid_EX,rs1_EX,Rs2_Valid_EX,rs2_EX,Write_Enable_MEM,rd_MEM,Alu_Out_MEM,Write_Enable_WB,rd_WB,          //rd after after stage 4 
Write_Back_Control_WB,Loaded_Data_WB,Alu_Out_WB,I_Type_Load_EX,S_Type_EX,J_Type_EX,I_Type_JAL_R_EX,Operand1_ACU_EX_Fwd,Operand1_DEU_EX_Fwd,Operand2_DEU_EX_Fwd);

assign Alu_Out = Alu_Out_EX;//Output of ALU
Stage_3 EX(PC_EX,Operand1_ACU_EX_Fwd,Operand2_ACU_EX,Operand1_DEU_EX_Fwd,Operand2_DEU_EX_Fwd,Alu_Cntrl_EX,J_Type_EX,I_Type_JAL_R_EX,Address_EX,Is_Branch_Taken,
Alu_Out_EX);

EX_MEM_Pipeline EXM(Clk,Reset,I_Type_Load_EX,S_Type_EX,PC_EX,Alu_Out_EX,Func3_EX,rd_EX,Write_Enable_EX,Address_EX,I_Type_Load_MEM,S_Type_MEM,PC_MEM,
Alu_Out_MEM,Func3_MEM,rd_MEM,Write_Enable_MEM,Address_MEM);

assign Mem_Enable = 1'b1;
Stage_4 MEM(Clk,Reset,I_Type_Load_MEM,S_Type_MEM,Mem_Enable,Func3_MEM,Address_MEM,Alu_Out_MEM,Loaded_Data_MEM);

MEM_WB_Pipeline MWB(Clk,Reset,Alu_Out_MEM,PC_MEM,Loaded_Data_MEM,I_Type_Load_MEM,rd_MEM,Write_Enable_MEM,
Alu_Out_WB,PC_WB,Loaded_Data_WB,Write_Back_Control_WB,rd_WB,Write_Enable_WB);

assign Mem_Out = Loaded_Data_WB;assign Data_Write_Back_Ot = Data_Write_Back;
Stage_5 WB(Alu_Out_WB,PC_WB,Loaded_Data_WB,Write_Back_Control_WB,Write_Enable_WB,Data_Write_Back);

assign rd_WB_0t = rd_WB;
endmodule