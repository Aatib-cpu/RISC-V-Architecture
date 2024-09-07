`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2024 02:55:01 AM
// Design Name: 
// Module Name: Pipeline_Management
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


module Pipeline_Management(
input [4:0] rs1_ID, 
input [4:0] rs2_ID,
input Rs1_Valid_ID,
input Rs2_Valid_ID,

input [4:0] rd_EX,   //Address of rd
input Write_Enable_EX,
input I_Type_Load_EX,

input Is_Branch_Taken,
output reg Do_Stall,
output reg [1:0] MUX_IF_PM,
output reg MUX_ID_PM
);

//Stall Checking
always@(*) begin
if (Rs1_Valid_ID && Write_Enable_EX && I_Type_Load_EX && (rs1_ID == rd_EX)) //Checking with Rs1
    Do_Stall = 1'b1;
else if (Rs2_Valid_ID && Write_Enable_EX && I_Type_Load_EX && (rs2_ID == rd_EX)) //Checking with Rs2
    Do_Stall = 1'b1;
else
    Do_Stall = 1'b0;
end

//Piplenine Register MUX Control
always@(*) 
if (Is_Branch_Taken) begin
    MUX_IF_PM = 2'b01; MUX_ID_PM = 1'b1; end //NOP  NOP
else if (Do_Stall) begin
    MUX_IF_PM = 2'b10; MUX_ID_PM = 1'b1; end //Freeze  NOP
else begin
    MUX_IF_PM = 2'b00; MUX_ID_PM = 1'b0; end //Normal Normal 


endmodule
