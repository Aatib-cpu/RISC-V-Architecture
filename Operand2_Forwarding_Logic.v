`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2024 03:07:03 AM
// Design Name: 
// Module Name: Operand2_Forwarding_Logic
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


module Operand2_Forwarding_Logic(
input Rs2_Valid_EX,        //rs1 Validity after Decode
input rs2_EX,           //rs1 after Decode

input Write_Enable_MEM,         //rd_Valid execute
input rd_MEM,         //rd after execute
input [31:0] Alu_Out_MEM,       //Alu from execute

input Write_Enable_WB,          //rd_Valid Memory
input rd_WB,          //rd after Memory
input [31:0] Loaded_Data_WB,    //Load from Memory

input [31:0] Operand2,
output reg [31:0] Operand2_Select,

output reg Do_Freeze
);

always@(*)begin
Do_Freeze = 1'b0;
if ((Rs2_Valid_EX == 1'b1)&&(Write_Enable_WB == 1'b1)&&(rs2_EX == rd_WB)&&(rs2_EX != 1'b0))
    begin Operand2_Select = Loaded_Data_WB; Do_Freeze = 1'b1; end
else if ((Rs2_Valid_EX == 1'b1)&&(Write_Enable_MEM == 1'b1)&&(rs2_EX==rd_MEM)&&(rs2_EX != 1'b0))
    Operand2_Select = Alu_Out_MEM;
else
    Operand2_Select = Operand2;
end

endmodule
