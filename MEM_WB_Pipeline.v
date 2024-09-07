`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2024 07:47:14 AM
// Design Name: 
// Module Name: MEM_WB_Pipeline
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


module MEM_WB_Pipeline(
input Clk, Reset,
input [31:0] Alu_Out_MEM,		//Output of ALU
input [31:0] PC_MEM,
input [31:0] Loaded_Data_MEM,
input I_Type_Load_MEM,
input [4:0] rd_MEM,   //Address of rd
input Write_Enable_MEM,

output reg [31:0] Alu_Out_WB,		//Output of ALU
output reg [31:0] PC_WB,
output reg [31:0] Loaded_Data_WB,
output reg Write_Back_Control_WB,
output reg [4:0] rd_WB,   //Address of rd
output reg Write_Enable_WB
);

always @(posedge Clk, posedge Reset)
        if (Reset==1) begin                                                 //Resetting the value
            PC_WB <= 0;
            rd_WB <= 0;
            Alu_Out_WB <= 0;
            Loaded_Data_WB <= 0;
            Write_Back_Control_WB <= 0;
            Write_Enable_WB <= 1'b1;	
            end
        else begin
            PC_WB <= PC_MEM;
            rd_WB <= rd_MEM;
            Alu_Out_WB <= Alu_Out_MEM;
            Loaded_Data_WB <= Loaded_Data_MEM;
            Write_Back_Control_WB <= I_Type_Load_MEM;
            Write_Enable_WB <= Write_Enable_MEM;	
            end
/*always@(posedge Clk)
begin
$display("\n MEM_WB_Pipeline");
$display("PC_WB: %b",PC_WB);
$display("Immediate_WB: %b",Immediate_WB);
$display("Alu_Out_WB: %b",Alu_Out_WB);
$display("Loaded_Data_WB: %b",Loaded_Data_WB);
$display("WriteBack_Control_WB: %b",WriteBack_Control_WB );
$display("rd_WB: %b",rd_WB);
end */          
endmodule

