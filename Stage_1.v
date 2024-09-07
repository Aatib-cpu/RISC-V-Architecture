`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2024 08:28:14 PM
// Design Name: 
// Module Name: Stage_1
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

module Stage_1(Clock,Reset,Do_Stall,Is_Branch_Taken,MUX_IF_PM,Jump_Address,Instruction_Register_ID,PC_IF,Instruction_Fetch_IF_PM);
input Clock;
input Reset;
input Do_Stall; //Stall input from Pipeline Management System
input Is_Branch_Taken; //Branch input from Pipeline Management System
input [1:0] MUX_IF_PM;
input [31:0] Jump_Address;//PC is loaded with this address for B_Type,JAL,JAL_R
input [31:0] Instruction_Register_ID;

output [31:0]PC_IF; //Output current PC value for further use
output reg [31:0]Instruction_Fetch_IF_PM;//Output 32-bit Instruction for further decoding

reg [31:0]Instruction_Fetch_IF;
reg [31:0]Address;   //32 bit Address for reading from Instruction Memory
reg [7:0] IM [0:63]; //Instruction Memory of 64Bytes

assign PC_IF = Address; 

always@(posedge Clock or posedge Reset)
begin
if(Reset)
Address <= 32'b0;
else
case({Is_Branch_Taken,Do_Stall})
2'b00: Address <= Address + 32'd4;
2'b10: Address <= Jump_Address;
default;
endcase
end
//Initializing Instruction Memory 
initial
begin                                   //func7 rs2   rs1   fun3  rd    Opcode 
    {IM[03],IM[02],IM[01],IM[00]} = 32'b000000000001_00110_000__00101_0000011; //NOP 
						                //func7 rs2   rs1   fun3  rd    Opcode    
    {IM[07],IM[06],IM[05],IM[04]} = 32'b0000000_00011_00010_000___00001_0110011; 
             					        //func7 rs2   rs1   fun3  rd    Opcode	
    {IM[11],IM[10],IM[09],IM[08]} = 32'b0000000_00100_00001_000___00010_0110011; 
                                        //func7 rs2   rs1   fun3  rd    Opcode    
    {IM[15],IM[14],IM[13],IM[12]} = 32'b0000000_00001_00010_000___00011_0110011; 
            					         //Immediate rs1   fun3 rd    Opcode    
    {IM[19],IM[18],IM[17],IM[16]} = 32'b0100000_00111_01000_000___00111_0110011;//1111111_00101_00101_000__01101_1100011;
            					         //Imm  rs2   rs1   fun3 imm   Opcode 
    {IM[23],IM[22],IM[21],IM[20]} = 32'b1111111_00101_00101_000__10001_1100011; //beq r5 r5 -16
                                           
    {IM[27],IM[26],IM[25],IM[24]} = 32'b000000000000_00000_000_00000_0010011; 
    
    {IM[31],IM[30],IM[29],IM[28]} = 32'b000000000000_00000_000_00000_0010011;
    
    {IM[35],IM[34],IM[33],IM[32]} = 32'b000000000000_00000_000_00000_0010011; 
    
    {IM[39],IM[38],IM[37],IM[36]} = 32'b000000000000_00000_000_00000_0010011; 
    
    {IM[43],IM[42],IM[41],IM[40]} = 32'b000000000000_00000_000_00000_0010011; 

    {IM[47],IM[46],IM[45],IM[44]} = 32'b000000000000_00000_000_00000_0010011; 

    {IM[51],IM[50],IM[49],IM[48]} = 32'b000000000000_00000_000_00000_0010011; 
     
    {IM[55],IM[54],IM[53],IM[52]} = 32'b000000000000_00000_000_00000_0010011; 

    {IM[59],IM[58],IM[57],IM[56]} = 32'b000000000000_00000_000_00000_0010011; 

    {IM[63],IM[62],IM[61],IM[60]} = 32'b000000000000_00000_000_00000_0010011; 
end
   
//Asynchronous read operation from Instruction Memory
always@(Address)
begin
Instruction_Fetch_IF = {IM[Address+3],IM[Address+2],IM[Address+1],IM[Address]};
end

//========================================================= MUX ==================================================================
always@(*) 
case(MUX_IF_PM)                         //func7 rs2   rs1   fun3 rd    Opcode
2'b01: Instruction_Fetch_IF_PM = 32'b0000000_00000_00000_000__00000_0110011;     // NOP Instruction_1____ADD R0, R0, R0
2'b10: Instruction_Fetch_IF_PM = Instruction_Register_ID;   //Freeze
default: Instruction_Fetch_IF_PM = Instruction_Fetch_IF;       
endcase
//================================================================================================================================
/*always@(PC_IF) begin
$display("\n Stage 1");
$display("PC_IF: %b ",PC_IF);
$display("Instruction_Fetch_IF: %b ",Instruction_Fetch_IF_PM);
end*/ 
endmodule