`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2024 03:07:03 AM
// Design Name: 
// Module Name: Operand1_Forwarding_Logic
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


module Operand1_Forwarding_Logic(
input Rs1_Valid_EX,        //rs1 Validity after Decode
input rs1_EX,              //rs1 after Decode

input Write_Enable_MEM,         //rd_Valid execute
input rd_MEM,         //rd after execute
input [31:0] Alu_Out_MEM,       //Alu from execute

input Write_Enable_WB,          //rd_Valid Memory
input rd_WB,          //rd after Memory
input [31:0] Loaded_Data_WB,    //Load from Memory

input [31:0] Operand1,
output reg [31:0] Operand1_Select,

output reg Do_Freeze
);

//{I_Type_Load_EX, S_Type_EX, B_Type_EX, U_Type_LUI_EX, U_Type_AUIPC_EX, J_Type_EX, I_Type_JAL_R_EX}
always@(*)begin
Do_Freeze = 1'b0;
if ((Rs1_Valid_EX == 1'b1)&&(Write_Enable_WB == 1'b1)&&(rs1_EX == rd_WB)&&(rs1_EX != 1'b0))
    begin Operand1_Select = Loaded_Data_WB; Do_Freeze = 1'b1; end
else if ((Rs1_Valid_EX == 1'b1)&&(Write_Enable_MEM == 1'b1)&&(rs1_EX==rd_MEM)&&(rs1_EX != 1'b0))
    Operand1_Select = Alu_Out_MEM;
else
    Operand1_Select = Operand1;
end

endmodule
