`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2024 07:46:13 AM
// Design Name: 
// Module Name: ID_EX_Pipeline
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

module ID_EX_Pipeline(
    input Clk, Reset,
    input [31:0] PC_ID,
    input [31:0] Operand1_ACU_ID_PM, //Operand 1 to Address ALU
    input [31:0] Operand2_ACU_ID_PM, //Operand 2 to Data ALU
    input [31:0] Operand1_DEU_ID_PM, //Operand 1 to Data ALU
    input [31:0] Operand2_DEU_ID_PM, //Operand 2 to Address ALU
    input [4:0] Alu_Cntrl_ID_PM,
    input [4:0] rs1_ID_PM,
    input [4:0] rs2_ID_PM,
    input [2:0] Func3_ID_PM,
    input [6:0] Immediate_Format_ID_PM,
    input [4:0] rd_ID_PM,   //Address of rd
    input Rs1_Valid_ID_PM,
    input Rs2_Valid_ID_PM,
    input Write_Enable_ID_PM,
    
    output reg I_Type_Load_EX, S_Type_EX, B_Type_EX, U_Type_LUI_EX, U_Type_AUIPC_EX, J_Type_EX, I_Type_JAL_R_EX,
    output reg [31:0] PC_EX,
    output reg [31:0] Operand1_ACU_EX, //Operand 1 to Address ALU
    output reg [31:0] Operand2_ACU_EX, //Operand 2 to Data ALU
    output reg [31:0] Operand1_DEU_EX, //Operand 1 to Data ALU
    output reg [31:0] Operand2_DEU_EX, //Operand 2 to Address ALU
    output reg [4:0] Alu_Cntrl_EX,
    output reg [4:0] rs1_EX,
    output reg [4:0] rs2_EX,
    output reg [2:0] Func3_EX,
    output reg [4:0] rd_EX,   //Address of rd
    output reg Rs1_Valid_EX,
    output reg Rs2_Valid_EX,
    output reg Write_Enable_EX
);

always @(posedge Clk, posedge Reset)
    begin
        if (Reset==1) begin                                                 //Resetting the value
            {I_Type_Load_EX, S_Type_EX, B_Type_EX, U_Type_LUI_EX, U_Type_AUIPC_EX, J_Type_EX, I_Type_JAL_R_EX}=7'b0000000;                         
            PC_EX <= 32'h00000000;                                          //Programing Counter
            Operand1_ACU_EX <= 32'h00000000;
            Operand2_ACU_EX <= 32'h00000000;
            Operand1_DEU_EX <= 32'h00000000;
            Operand2_DEU_EX <= 32'h00000000;
            Alu_Cntrl_EX <= 5'b00000;
            rs1_EX <= 5'b00000;
            rs2_EX <= 5'b00000;
            Func3_EX <= 3'b000;
            rd_EX <= 5'b00000;
            Rs1_Valid_EX <= 1'b1;
            Rs2_Valid_EX <= 1'b1;
            Write_Enable_EX <= 1'b1;
            end
        else begin
            {I_Type_Load_EX, S_Type_EX, B_Type_EX, U_Type_LUI_EX, U_Type_AUIPC_EX, J_Type_EX, I_Type_JAL_R_EX}=Immediate_Format_ID_PM;                           
            PC_EX <= PC_ID;                                          //Programing Counter
            Operand1_ACU_EX <= Operand1_ACU_ID_PM;
            Operand2_ACU_EX <= Operand2_ACU_ID_PM;
            Operand1_DEU_EX <= Operand1_DEU_ID_PM;
            Operand2_DEU_EX <= Operand2_DEU_ID_PM;
            Alu_Cntrl_EX <= Alu_Cntrl_ID_PM;//Alu Cntrol{Func7[5],Func3};
            rs1_EX <= rs1_ID_PM;
            rs2_EX <= rs2_ID_PM;
            Func3_EX <= Func3_ID_PM;//Function 3
            rd_EX <= rd_ID_PM;
            Rs1_Valid_EX <= Rs1_Valid_ID_PM;
            Rs2_Valid_EX <= Rs2_Valid_ID_PM;
            Write_Enable_EX <= Write_Enable_ID_PM;
            end
        end       
endmodule