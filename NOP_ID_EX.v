`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2024 11:50:30 PM
// Design Name: 
// Module Name: NOP_ID_EX
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


module NOP_ID_EX(
input Is_Branch_Taken,
input [31:0] Immediate_ID,
input [31:0] Operand1, Operand2,
input [4:0] Alu_Cntrl_ID,
input [31:0] Rout2_ID,
input [2:0] Func3_ID,
input [6:0] Immediate_Format_ID,
input [4:0] rd_ID,   //Address of rd
input Rs1_Valid_ID,
input Rs2_Valid_ID,
input Write_Enable_ID,
input [1:0] WriteBack_Control_ID,

output reg [31:0] Immediate_ID_NOP,
output reg [31:0] Operand1_NOP, Operand2_NOP,
output reg [4:0] Alu_Cntrl_ID_NOP,
output reg [31:0] Rout2_ID_NOP,
output reg [2:0] Func3_ID_NOP,
output reg [6:0] Immediate_Format_ID_NOP,
output reg [4:0] rd_ID_NOP,   //Address of rd
output reg Rs1_Valid_ID_NOP,
output reg Rs2_Valid_ID_NOP,
output reg Write_Enable_ID_NOP,
output reg [1:0] WriteBack_Control_ID_NOP
);
  
always@(*)
if (Is_Branch_Taken) begin   
Immediate_ID_NOP = 0;
Operand1_NOP = 0;
Operand2_NOP = 0;
Alu_Cntrl_ID_NOP = 0;
Rout2_ID_NOP = 0;
Func3_ID_NOP = 0;
Immediate_Format_ID_NOP = 0;
rd_ID_NOP = 0;
WriteBack_Control_ID_NOP = 0;
Rs1_Valid_ID_NOP = 0;
Rs2_Valid_ID_NOP = 0;
Write_Enable_ID_NOP = 0;
end

else begin
Immediate_ID_NOP = Immediate_ID;
Operand1_NOP = Operand1;
Operand2_NOP = Operand2;
Alu_Cntrl_ID_NOP = Alu_Cntrl_ID;
Rout2_ID_NOP = Rout2_ID;
Func3_ID_NOP = Func3_ID;
Immediate_Format_ID_NOP = Immediate_Format_ID;
rd_ID_NOP = rd_ID;
WriteBack_Control_ID_NOP = WriteBack_Control_ID;
Rs1_Valid_ID_NOP = 0;
Rs2_Valid_ID_NOP = 0;
Write_Enable_ID_NOP = Write_Enable_ID;
end
endmodule
