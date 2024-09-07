`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2024 11:41:08 PM
// Design Name: 
// Module Name: NOP_IF_ID
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


module NOP_IF_ID(
input Is_Branch_Taken,
input [31:0] Instruction_Fetch,
output reg [31:0] Instruction_Fetch_NOP
);
always@(*)
if (Is_Branch_Taken)    //func7 rs2   rs1   fun3 rd    Opcode
Instruction_Fetch_NOP = 32'b0000000_00000_00000_000__00000_0110011;     // Instruction_1____ADD R0, R0, R0
else
Instruction_Fetch_NOP = Instruction_Fetch;


endmodule
