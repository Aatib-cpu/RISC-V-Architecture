`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2024 01:33:50 AM
// Design Name: 
// Module Name: Instruction_Memory
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


module Instruction_Memory(
input [31:0] Pc_Out,
input Reset,
output reg [31:0] Instruction_Fetch
);

reg [7:0] RAM [0:27];
    
always @(posedge Reset) begin			
						                    //func7 rs2   rs1   fun3  rd    Opcode
	{RAM[00],RAM[01],RAM[02],RAM[03]} = 32'b000000000000_01011_000_00000_0000011; // Instruction_1____ADD R1, R1, R1
						                    //func7 rs2   rs1   fun3  rd    Opcode
	{RAM[04],RAM[05],RAM[06],RAM[07]} = 32'b000000000000_00011_000_00000_0000011; // Instruction_1____ADD R2, R2, R2
             					            //func7 rs2   rs1   fun3  rd    Opcode	
	{RAM[08],RAM[09],RAM[10],RAM[11]} = 32'b000000000000_01001_000_00000_0000011; // Instruction_2____SUB R5, R2, R5
                                            //func7 rs2   rs1   fun3  rd    Opcode
	{RAM[12],RAM[13],RAM[14],RAM[15]} = 32'b000000000000_01010_000_00000_0000011; // Instruction_3____AND R3, R2, R1
            					            //Immediate  rs1   fun3  rd    Opcode
    {RAM[16],RAM[17],RAM[18],RAM[19]} = 32'b000000000000_01000_001_00000_0000011; // Instruction_4____ADDi, R3, R5, 3
            					            //func7 rs2   rs1   fun3  rd    Opcode
    {RAM[20],RAM[21],RAM[22],RAM[23]} = 32'b000000000000_01111_010_00000_0000011; // Instruction_5____ADD, R6, R5, R4
                                            //Imm   rs2   rs1   func3 imm   opcode
    {RAM[24],RAM[25],RAM[26],RAM[27]} = 32'b000000000000_11111_100_00000_0000011; // Instruction_5____BEQ, R5, R5,-24
               
//            RAM[20] = 8'h00;   // Instruction_6
//            RAM[21] = 8'h30;  
//            RAM[22] = 8'h82;  
//            RAM[23] = 8'h33;
//            RAM[24] = 8'h00;   // Instruction_7
//            RAM[25] = 8'h12;  
//            RAM[26] = 8'h02;  
//            RAM[27] = 8'hB3;
//            RAM[28] = 8'h00;  // Instruction_8
//            RAM[29] = 8'h42;  
//            RAM[30] = 8'h83;  
//            RAM[31] = 8'h33;
//            RAM[32] = 8'h00;  // Instruction_9
//            RAM[33] = 8'h21;  
//            RAM[34] = 8'h80;  
//            RAM[35] = 8'hB3;
//            RAM[36] = 8'h00;  // Instruction_10
//            RAM[37] = 8'h1A;  
//            RAM[38] = 8'h2F;  
//            RAM[39] = 8'h23;
//            RAM[40] = 8'h01;  // Instruction_10
//            RAM[41] = 8'hEA;  
//            RAM[42] = 8'h28;  
//            RAM[43] = 8'h03;   
//            RAM[44] = 8'hAB;  // Instruction_10
//            RAM[45] = 8'hCD;  
//            RAM[46] = 8'hEF;  
//            RAM[47] = 8'h97;       
        end

always @(Pc_Out) begin
        	Instruction_Fetch = {RAM[Pc_Out[6:0]],RAM[Pc_Out[6:0]+1],RAM[Pc_Out[6:0]+2],RAM[Pc_Out[6:0]+3]};
	end
endmodule

