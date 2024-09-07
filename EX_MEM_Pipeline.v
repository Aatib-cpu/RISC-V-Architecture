`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2024 07:46:53 AM
// Design Name: 
// Module Name: EX_MEM_Pipeline
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

module EX_MEM_Pipeline(
input Clk, Reset,

input I_Type_Load_EX_PM, 
input S_Type_EX_PM,
input [31:0] PC_EX,
input [31:0] Alu_Out_EX_PM,
input [2:0] Func3_EX_PM,
input [4:0] rd_EX_PM,   //Address of rd
input Write_Enable_EX_PM,
input [31:0] Address_EX_PM,		//Output of ALU

output reg I_Type_Load_MEM, S_Type_MEM,
output reg [31:0] PC_MEM,
output reg [31:0] Alu_Out_MEM,
output reg [2:0] Func3_MEM,
output reg [4:0] rd_MEM,   //Address of rd
output reg Write_Enable_MEM,
output reg [31:0] Address_MEM		//Output of ALU
);

always @(posedge Clk, posedge Reset)
        if (Reset==1) begin                                                 //Resetting the value
            I_Type_Load_MEM <= 0; 
            S_Type_MEM <= 0;
            PC_MEM <= 0;
            Alu_Out_MEM <= 0;
            Func3_MEM <= 0;
            rd_MEM <= 0;   
            Address_MEM <= 0;
            Write_Enable_MEM <= 1'b1;	
            end
        else begin
            I_Type_Load_MEM <= I_Type_Load_EX_PM; 
            S_Type_MEM <= S_Type_EX_PM;
            PC_MEM <= PC_EX;
            Alu_Out_MEM <= Alu_Out_EX_PM;
            Func3_MEM <= Func3_EX_PM;
            rd_MEM <= rd_EX_PM;   
            Address_MEM <= Address_EX_PM;
            Write_Enable_MEM <= Write_Enable_EX_PM;	
            end 
            
/*always@(posedge Clk) begin
$display("\n EX_MEM_Pipeline");
$display("I_Type_Load_MEM: %b",I_Type_Load_MEM);
$display("S_Type_MEM: %b",S_Type_MEM);
$display("Immediate_MEM: %b",Immediate_MEM);
$display("PC_MEM: %b",PC_MEM);
$display("Rout2_MEM: %b",Rout2_MEM);
$display("Func3_MEM: %b",Func3_MEM);
$display("rd_MEM: %b",rd_MEM);
$display("WriteBack_Control_MEM: %b",WriteBack_Control_MEM);
$display("Alu_Out_MEM: %b",Alu_Out_MEM);
end*/
   
endmodule
