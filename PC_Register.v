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

module PC_Register(
input Clk, Reset,
input [31:0] Pc_In,
output reg [31:0] Pc_Out
); 
  
always @(posedge Clk, posedge Reset)
    if (Reset)
        Pc_Out <= 32'h00000000;
    else 
        Pc_Out <= Pc_In;
             
endmodule
