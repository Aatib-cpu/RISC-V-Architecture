`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2024 07:55:12 PM
// Design Name: 
// Module Name: PC_Mux
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


module PC_Mux(Pc_Add_Out, Pc_Out, Branch_Address, Do_Stall, Is_Branch_Taken, Pc_In);
    input [31:0] Pc_Add_Out, Pc_Out, Branch_Address; //Branch Address is Alu_Out
    input Do_Stall, Is_Branch_Taken;
    output reg [31:0] Pc_In;

    always @(*)
        case ({Is_Branch_Taken,Do_Stall}) 
        2'b10: Pc_In = Branch_Address;
        //2'b11: Pc_In = Branch_Address;  
        2'b01: Pc_In = Pc_Out;
        default: Pc_In = Pc_Add_Out;
        endcase
endmodule
