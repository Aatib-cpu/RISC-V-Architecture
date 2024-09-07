`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2024 02:18:04 AM
// Design Name: 
// Module Name: Data_Memory
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

module Data_Memory( Reset, Address, Store_Data, Is_Store, Is_Load, Load_Data );

input Reset, Is_Load, Is_Store;
input [6:0] Address;
input [31:0] Store_Data;
output reg [31:0] Load_Data;

reg [7:0] Mem [0:127];
integer i;

always@(Reset, Is_Load, Is_Store)
	if (Reset)
		for (i=0;i<128;i=i+1)
			Mem [i] = i;
	else if (Is_Store) begin
		Mem [Address] = Store_Data[31:24];
		Mem [Address+1] = Store_Data[23:16];
		Mem [Address+2] = Store_Data[15:8];
		Mem [Address+3] = Store_Data[7:0];
	end
	else if (Is_Load)
		Load_Data = {Mem[Address], Mem[Address+1], Mem[Address+2], Mem[Address+3]};
	else 
		Load_Data = 32'hxxxx_xxxx; // No Memory Operation
endmodule
