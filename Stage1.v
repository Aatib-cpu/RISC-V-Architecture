`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 02:59:00 PM
// Design Name: 
// Module Name: Stage1
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


module Stage1( 
input Clk, Reset,
input Is_JAL, Is_JAL_R, Is_Branch_Taken,
input [31:0] Branch_Address 
);

wire [31:0] Pc_Add_Out, Pc_In, Pc_Out, Instruction_Fetch;    

PC_Mux PM(Pc_Add_Out, Branch_Address, Is_JAL, Is_JAL_R, Is_Branch_Taken, Pc_In);
PC_Adder PA(Pc_Out, Pc_Add_Out);
PC_Register PR(Clk, Reset, Pc_In, Pc_Out); 
Instruction_Memory IM(Pc_Out, Reset, Instruction_Fetch);   

endmodule


