`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2024 12:58:40 PM
// Design Name: 
// Module Name: Forwarding_Unit
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


module Forwarding_Unit(
//Operand inputs from Decode stage (Stage 2)
input [31:0] Operand1_ACU_EX,
input [31:0] Operand1_DEU_EX,
input [31:0] Operand2_DEU_EX,

input Rs1_Valid_EX,        //rs1 Validity after Decode
input [4:0] rs1_EX,              //rs1 after Decode

input Rs2_Valid_EX,        //rs1 Validity after Decode
input [4:0] rs2_EX,           //rs1 after Decode

//Forwarding from execution (after stage3)
input Write_Enable_MEM,         //rd_Valid execute
input [4:0] rd_MEM,         //rd after execute
input [31:0] Alu_Out_MEM,       //Alu from execute

//Forwarding from memory (after stage4)
input Write_Enable_WB,          //rd_Valid after stage 4 
input [4:0] rd_WB,          //rd after after stage 4 
input Write_Back_Control_WB,            //Load Type format after stage 4 
input [31:0] Loaded_Data_WB,    //Load from memory
input [31:0] Alu_Out_WB,       //Alu after stage 4

//Format Type
input I_Type_Load_EX, S_Type_EX, J_Type_EX, I_Type_JAL_R_EX,

//Forwarding Outputs
output reg [31:0] Operand1_ACU_EX_Fwd,
output reg [31:0] Operand1_DEU_EX_Fwd,
output reg [31:0] Operand2_DEU_EX_Fwd
);

//For Operand1_ACU 
always@(*)
if (Rs1_Valid_EX&&Write_Enable_MEM&&(rs1_EX==rd_MEM)&&(rs1_EX!=0)&&(I_Type_Load_EX||I_Type_JAL_R_EX||S_Type_EX))
    Operand1_ACU_EX_Fwd = Alu_Out_MEM;
else if (Rs1_Valid_EX&&Write_Enable_WB&&(rs1_EX == rd_WB)&&(rs1_EX!=0)&&(I_Type_Load_EX||I_Type_JAL_R_EX||S_Type_EX)&&Write_Back_Control_WB)
    Operand1_ACU_EX_Fwd = Loaded_Data_WB; //Dependence on Loaded data
else if (Rs1_Valid_EX&&Write_Enable_WB&&(rs1_EX == rd_WB)&&(rs1_EX!=0)&&(I_Type_Load_EX||I_Type_JAL_R_EX||S_Type_EX)) 
    Operand1_ACU_EX_Fwd = Alu_Out_WB; //Dependence on write back data
else
    Operand1_ACU_EX_Fwd = Operand1_ACU_EX; 

//For Operand1_DEU 
always@(*)
if (Rs1_Valid_EX&&Write_Enable_MEM&&(rs1_EX == rd_MEM)&&(rs1_EX!=0)&&(!I_Type_Load_EX)&&(!I_Type_JAL_R_EX)&&(!S_Type_EX))
    Operand1_DEU_EX_Fwd = Alu_Out_MEM;
else if (Rs1_Valid_EX&&Write_Enable_WB&&(rs1_EX == rd_WB)&&(rs1_EX!=0)&&(!I_Type_Load_EX)&&(!I_Type_JAL_R_EX)&&(!S_Type_EX)&&Write_Back_Control_WB)
    Operand1_DEU_EX_Fwd = Loaded_Data_WB;
else if (Rs1_Valid_EX&&Write_Enable_WB&&(rs1_EX == rd_WB)&&(rs1_EX!=0)&&(!I_Type_Load_EX)&&(!I_Type_JAL_R_EX)&&(!S_Type_EX))
    Operand1_DEU_EX_Fwd = Alu_Out_WB;
else
    Operand1_DEU_EX_Fwd = Operand1_DEU_EX;

//For Operand2_DEU
always@(*)
if (Rs2_Valid_EX&&Write_Enable_MEM&&(rs2_EX == rd_MEM)&&(rs2_EX!=0))
    Operand2_DEU_EX_Fwd = Alu_Out_MEM;
else if (Rs2_Valid_EX&&Write_Enable_WB &&(rs2_EX == rd_WB)&&(rs2_EX!=0)&&Write_Back_Control_WB)
    Operand2_DEU_EX_Fwd = Loaded_Data_WB;
else if (Rs2_Valid_EX&&Write_Enable_WB &&(rs2_EX == rd_WB)&&(rs2_EX!=0))
    Operand2_DEU_EX_Fwd = Alu_Out_WB;
else
    Operand2_DEU_EX_Fwd = Operand2_DEU_EX;

/*always@(*) begin
$display("\n Forwarding unit");
$display("rs1_EX: %b ",rs1_EX);
$display("rs2_EX: %b ",rs2_EX);
$display("rd_MEM: %b ",rd_MEM);
$display("rd_WB: %b ",rd_WB);
$display("Operand1_ACU_EX_Fwd: %d ",Operand1_ACU_EX_Fwd);
$display("Operand1_DEU_EX_Fwd: %d ",Operand1_DEU_EX_Fwd);
$display("Operand2_DEU_EX_Fwd: %d ",Operand2_DEU_EX_Fwd);
$display("Alu_Out_MEM: %d",Alu_Out_MEM);
$display("Loaded_Data_WB: %d",Loaded_Data_WB);
$display("Alu_Out_WBn: %d",Alu_Out_WB);
end */  
endmodule
