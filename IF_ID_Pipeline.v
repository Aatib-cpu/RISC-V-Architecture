`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2024 07:45:50 AM
// Design Name: 
// Module Name: IF_ID_Pipeline
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

module IF_ID_Pipeline(
    input Clk, Reset,
    input [31:0] Instruction_Fetch_IF_PM,
    input [31:0] PC_IF,
    output reg [31:0] Instruction_Register_ID,
    output reg [31:0] PC_ID,
    output reg [4:0] rs1_ID, 
    output reg [4:0] rs2_ID, 
    output reg [4:0] rd_ID,
    output reg [6:0] Opcode,
    output reg [2:0] Func3_ID
);

always @(posedge Clk, posedge Reset)
    begin
        if (Reset==1) begin                                                 //Resetting the value
            Instruction_Register_ID <= 32'h00000000;                           //Instruction fetched from Instruction memory
            PC_ID <= 32'h00000000;                                          //Programing Counter
            rs1_ID <= 5'b00000;                                     //rs1
            rs2_ID <= 5'b00000;                                     //rs2
            rd_ID <= 5'b00000;                                       //rd
            Opcode <= 7'b0110011;                                           //7 bit opcode
            Func3_ID <= 3'b000;                                             //Function 3
            end
        else begin
            Instruction_Register_ID <= Instruction_Fetch_IF_PM;                      //Instruction fetched from Instruction memory
            PC_ID <= PC_IF;                                                     //Programing Counter
            rs1_ID <= Instruction_Fetch_IF_PM[19:15];                     //rs1
            rs2_ID <= Instruction_Fetch_IF_PM[24:20];                     //rs2
            rd_ID <= Instruction_Fetch_IF_PM[11:7];                        //rd
            Opcode <= Instruction_Fetch_IF_PM[6:0];                               //7 bit opcode
            Func3_ID <= Instruction_Fetch_IF_PM[14:12];                           //Function 3
            end
        end 
        
 /*always@(posedge Clk) 
        begin
            $display("\n IF_ID_Pipeline");
            $display("Instruction_Register: %b ",Instruction_Register_ID); 
            $display("PC_ID: %b ",PC_ID);
            $display("rs_1: %d ",rs1_ID); 
            $display("rs_2: %d ",rs2_ID);
            $display("rd: %b ",rd_ID);
            $display("Opcode: %b ",Opcode);
            $display("Func3_ID: %b ",Func3_ID);
        end */   
endmodule
