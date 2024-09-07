`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: BIRLA INSTITUTE of TECHNOLOGY and Science, Pilani (BITS Pilani)
// Engineer: M.E. Microelectronics Dissertation 2022-24
// 
// Create Date: 03/20/2024 07:44:42 PM
// Design Name: RISC V 
// Module Name: PC_Mux
// Project Name: Implementation of RISC V
// Target Devices: ASIC 
// Tool Versions: Vivad0 2020.2 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module PC_Adder(
input [31:0] Pc_Out,
output [31:0] Pc_Add_Out
);

assign Pc_Add_Out = Pc_Out + 32'h0000_0004;

endmodule