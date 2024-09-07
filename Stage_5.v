`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2024 04:33:13 AM
// Design Name: 
// Module Name: Stage_5
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


module Stage_5(
input [31:0] Alu_Out_WB,		//Output of ALU
input [31:0] PC_WB,
input [31:0] Loaded_Data_WB,
input Write_Back_Control_WB,
input  Write_Enable_WB,
output [31:0] Data_Write_Back
);

assign Data_Write_Back = Write_Back_Control_WB?Loaded_Data_WB:Alu_Out_WB;
//assign Data_Write_Back = WriteBack_Control_WB[1]?(WriteBack_Control_WB[0]?Alu_Out_WB:Immediate_WB):(WriteBack_Control_WB[0]?Loaded_Data_WB:Alu_Out_WB);

/*always@(PC_WB)
begin
$display("\n Stage 5");
$display("Data_Write_Back: %0d",Data_Write_Back);
$display("Alu_Out_WB: %0d",Alu_Out_WB);
$display("PC_WB: %0b",PC_WB);
$display("Loaded_Data_WB: %0d",Loaded_Data_WB);
$display("WriteBack_Control_WB: %b",WriteBack_Control_WB );
$display("Write_Enable_WB: %b",Write_Enable_WB );
end*/
endmodule


