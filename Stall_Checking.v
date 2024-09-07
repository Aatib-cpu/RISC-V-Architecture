`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2024 08:43:37 PM
// Design Name: 
// Module Name: Stall_Checking
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


module Stall_Checking(
input [4:0] rs1_ID, 
input [4:0] rs2_ID,
input Rs1_Valid_ID,
input Rs2_Valid_ID,

input [4:0] rd_EX,   //Address of rd
input Write_Enable_EX,
input I_Type_Load_EX,

output reg Do_Stall
);

always@(*) begin

//Checking with Rs1
if (Rs1_Valid_ID && Write_Enable_EX && I_Type_Load_EX && (rs1_ID == rd_EX))
    Do_Stall = 1'b1;
else 
    Do_Stall = 1'b0;

//Checking with Rs2
if (Rs2_Valid_ID && Write_Enable_EX && I_Type_Load_EX && (rs2_ID == rd_EX))
    Do_Stall = 1'b1;
else
    Do_Stall = 1'b0;

end

endmodule
