`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2024 07:14:07 AM
// Design Name: 
// Module Name: Stage_2
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

module Stage_2(
input Clk, Reset,           //Clock and Reset Signal
input Read_Enable_1,        //Read Enable for rs1
input Read_Enable_2,        //Read Enable for rs2
input Write_Enable_WB,         //Write Enable for rd
input [31:0] PC_ID,        //PC_Value
input [31:0] Data_in,       //Data to be written in rd 
input [4:0] rs1_ID, //Address of rs1
input [4:0] rs2_ID, //Address of rs2
input [4:0] rd_ID,
input [4:0] rd_WB,   //Address of rd 
input [31:0] IR,            //Instruction Register
input [2:0] Func3_ID,
input MUX_ID_PM,

output reg [31:0] Operand1_ACU_ID_PM, //Operand 1 to Address ALU
output reg [31:0] Operand2_ACU_ID_PM, //Operand 2 to Data ALU
output reg [31:0] Operand1_DEU_ID_PM, //Operand 1 to Data ALU
output reg [31:0] Operand2_DEU_ID_PM, //Operand 2 to Address ALU
output reg [4:0] Alu_Cntrl_ID_PM,
output reg [4:0] rs1_ID_PM,
output reg [4:0] rs2_ID_PM,
output reg [2:0] Func3_ID_PM,
output reg [6:0] Immediate_Format_ID_PM,
output reg [4:0] rd_ID_PM,   //Address of rd
output reg Rs1_Valid_ID_PM,
output reg Rs2_Valid_ID_PM,
output reg Write_Enable_ID_PM
);
reg [4:0] Alu_Cntrl_ID; //ALU Control
reg [31:0] Operand1_ACU_ID; //Operand 1 to Address ALU
reg [31:0] Operand2_ACU_ID; //Operand 2 to Data ALU
reg [31:0] Operand1_DEU_ID; //Operand 1 to Data ALU
reg [31:0] Operand2_DEU_ID; //Operand 2 to Address ALU              
wire [6:0] Immediate_Format_ID;
wire Rs1_Valid_ID;
wire Rs2_Valid_ID;
wire Write_Enable_ID;

reg [31:0] Immediate;//Immediate Value 

//All Format Specifier
reg R_Type;
reg I_Type_Arithmetic; 
reg I_Type_Load; 
reg I_Type_Shift; 
reg S_Type; 
reg U_Type_LUI; 
reg B_Type;
reg U_Type_AUIPC;
reg J_Type;
reg I_Type_JAL_R;
//=============================================== Register File =================================================================
reg [31:0] Rout1;               //Output Value at rs1
reg [31:0] Rout2;               //Output Value at rs2
reg [31:0] Register_Bank [0:31];//Register file 32 by 32
integer i;                      //Index value of Register file

//Initializing Register File 
always@(posedge Reset) 
	for (i=0;i<32;i=i+1) begin
		Register_Bank [i] <= i;                    //Initializing Register File with its Index Value
		//$display("Register_Bank[%0d] = %0b",i,i); //Displaying Register File 
		end

//Writing Data in Register File 		
always@(negedge Clk)
    if (Write_Enable_WB)
        Register_Bank[rd_WB] <= Data_in;      //Initializing Register File with its Index Value

//Reading Data from Register File 
always@(rs1_ID, rs2_ID, Read_Enable_1, Read_Enable_2, Register_Bank) begin
    if (Read_Enable_1)
        Rout1 = Register_Bank[rs1_ID];      //Reading Value at rs1 from Register File
    else
        Rout1 = 0;   

    if (Read_Enable_2)
        Rout2 = Register_Bank[rs2_ID];      //Reading Value at rs2 from Register File
    else
        Rout2 = 0;    
end     

//Displaying modified Register File 
always@(Register_Bank) 
    for (i=0;i<32;i=i+1) begin
		$display("Register_Bank[%0d] = %0d",i,Register_Bank[i]);  //Displaying modified Register File 
		end                     

//===============================================================================================================================

//=============================================== Immediate Format Finder =======================================================
always@(IR) begin
R_Type = 0; I_Type_Arithmetic = 0; I_Type_Shift = 0; I_Type_Load = 0; S_Type = 0; B_Type = 0; U_Type_LUI = 0; 
U_Type_AUIPC = 0; J_Type = 0; I_Type_JAL_R = 0;
casex (IR)
32'b0000000_xxxxx_xxxxx_000_xxxxx_0110011: R_Type = 1;     //ADD
32'b0100000_xxxxx_xxxxx_000_xxxxx_0110011: R_Type = 1;     //SUB
32'b0000000_xxxxx_xxxxx_001_xxxxx_0110011: R_Type = 1;     //SLL 
32'b0000000_xxxxx_xxxxx_010_xxxxx_0110011: R_Type = 1;     //SLT 
32'b0000000_xxxxx_xxxxx_011_xxxxx_0110011: R_Type = 1;     //SLTU 
32'b0000000_xxxxx_xxxxx_100_xxxxx_0110011: R_Type = 1;     //XOR 
32'b0000000_xxxxx_xxxxx_101_xxxxx_0110011: R_Type = 1;     //SRL 
32'b0100000_xxxxx_xxxxx_101_xxxxx_0110011: R_Type = 1;     //SRA
32'b0000000_xxxxx_xxxxx_110_xxxxx_0110011: R_Type = 1;     //OR 
32'b0000000_xxxxx_xxxxx_111_xxxxx_0110011: R_Type = 1;     //AND
//I-arithmatic Format Detection
32'bxxx_xxxx_xxxxx_xxxxx_000_xxxxx_0010011: I_Type_Arithmetic = 1;     //ADDI 
32'bxxx_xxxx_xxxxx_xxxxx_010_xxxxx_0010011: I_Type_Arithmetic = 1;     //SLTI
32'bxxx_xxxx_xxxxx_xxxxx_011_xxxxx_0010011: I_Type_Arithmetic = 1;     //SLTIU
32'bxxx_xxxx_xxxxx_xxxxx_100_xxxxx_0010011: I_Type_Arithmetic = 1;     //XORI
32'bxxx_xxxx_xxxxx_xxxxx_110_xxxxx_0010011: I_Type_Arithmetic = 1;     //ORI
32'bxxx_xxxx_xxxxx_xxxxx_111_xxxxx_0010011: I_Type_Arithmetic = 1;     //ANDI 
32'b000_0000_xxxxx_xxxxx_001_xxxxx_0010011: begin I_Type_Arithmetic = 1; I_Type_Shift = 1; end   //SLLI
32'b000_0000_xxxxx_xxxxx_101_xxxxx_0010011: begin I_Type_Arithmetic = 1; I_Type_Shift = 1; end   //SRLI
32'b010_0000_xxxxx_xxxxx_101_xxxxx_0010011: begin I_Type_Arithmetic = 1; I_Type_Shift = 1; end   //SRAI
//I-load Format Detection
32'bxxx_xxxx_xxxxx_xxxxx_000_xxxxx_0000011: I_Type_Load = 1;     //LB
32'bxxx_xxxx_xxxxx_xxxxx_001_xxxxx_0000011: I_Type_Load = 1;     //LH
32'bxxx_xxxx_xxxxx_xxxxx_010_xxxxx_0000011: I_Type_Load = 1;     //LW
32'bxxx_xxxx_xxxxx_xxxxx_100_xxxxx_0000011: I_Type_Load = 1;     //LBU
32'bxxx_xxxx_xxxxx_xxxxx_101_xxxxx_0000011: I_Type_Load = 1;     //LHU
//S Format Detection
32'bxxx_xxxx_xxxxx_xxxxx_000_xxxxx_0100011: S_Type = 1;     //SB 
32'bxxx_xxxx_xxxxx_xxxxx_001_xxxxx_0100011: S_Type = 1;     //SH
32'bxxx_xxxx_xxxxx_xxxxx_010_xxxxx_0100011: S_Type = 1;     //SW
//B Format Detection
32'bxxx_xxxx_xxxxx_xxxxx_000_xxxxx_1100011: B_Type = 1;     //BEQ
32'bxxx_xxxx_xxxxx_xxxxx_001_xxxxx_1100011: B_Type = 1;     //BNE 
32'bxxx_xxxx_xxxxx_xxxxx_100_xxxxx_1100011: B_Type = 1;     //BLT 
32'bxxx_xxxx_xxxxx_xxxxx_101_xxxxx_1100011: B_Type = 1;     //BGE 
32'bxxx_xxxx_xxxxx_xxxxx_110_xxxxx_1100011: B_Type = 1;     //BLTU 
32'bxxx_xxxx_xxxxx_xxxxx_111_xxxxx_1100011: B_Type = 1;     //BGEU
//U(LUI) Format Detection
32'bxxx_xxxx_xxxxx_xxxxx_xxx_xxxxx_0110111: U_Type_LUI = 1;     //LUI
//U(AUIPC) Format Detection
32'bxxx_xxxx_xxxxx_xxxxx_xxx_xxxxx_0010111: U_Type_AUIPC = 1;   //AUIPC
//JAL Format Detection
32'bxxx_xxxx_xxxxx_xxxxx_xxx_xxxxx_1101111: J_Type = 1;         //JAL
//JALR Format Detection
32'bxxx_xxxx_xxxxx_xxxxx_000_xxxxx_1100111: I_Type_JAL_R = 1;   //JALR
endcase 
end
//===============================================================================================================================

//=============================================== Immediate Generator ===========================================================
always@(*) begin
Immediate = 0;
case ({I_Type_Arithmetic, I_Type_Load, S_Type, B_Type, U_Type_LUI, U_Type_AUIPC, J_Type, I_Type_JAL_R})
	8'b10000000: Immediate = {{20{IR[31]}}, IR[31:20]};                    //I Type_Aritmetic 
	8'b01000000: Immediate = {{20{IR[31]}}, IR[31:20]};                    //I Type_Load
	8'b00100000: Immediate = {{20{IR[31]}}, IR[31:25], IR[11:7]};                      //S Type Store
	8'b00010000: Immediate = {{20{IR[31]}},IR[31],IR[7], IR[30:25], IR[11:8],{1'b0}};  //B Type Branch
	8'b00001000,8'b00000100 : Immediate = {IR[31:12], {12{1'b0}}};                     //U Type LUI AUIPC 
	8'b00000010: Immediate = {{11{IR[31]}},IR[19:12], IR[20], IR[30:21],{1'b0}};       //J Type Jump
	8'b00000001: Immediate = {{20{IR[31]}}, IR[31:20]};                         //I Type_JAL_R
//default: Immediate = 0;
endcase
end
//===============================================================================================================================

//=============================================== Operand Selection =============================================================
always@(*) begin
case ({R_Type, I_Type_Arithmetic, I_Type_Shift, I_Type_Load, I_Type_JAL_R, S_Type, B_Type, U_Type_LUI, U_Type_AUIPC, J_Type})
10'b1000000000: begin Operand1_ACU_ID=0; Operand2_ACU_ID=0; Operand1_DEU_ID=Rout1; Operand2_DEU_ID=Rout2; end              //R Type
10'b0100000000: begin Operand1_ACU_ID=0; Operand2_ACU_ID=0; Operand1_DEU_ID=Rout1; Operand2_DEU_ID=Immediate; end          //I Type Arithmetic
10'b0110000000: begin Operand1_ACU_ID=0; Operand2_ACU_ID=0; Operand1_DEU_ID=Rout1; Operand2_DEU_ID=Immediate; end          //I Type Shift
10'b0001000000: begin Operand1_ACU_ID=Rout1; Operand2_ACU_ID=Immediate; Operand1_DEU_ID=0; Operand2_DEU_ID=0; end          //I Type Load
10'b0000100000: begin Operand1_ACU_ID=Rout1; Operand2_ACU_ID=Immediate; Operand1_DEU_ID=PC_ID; Operand2_DEU_ID=32'h0000_0004; end        //I Type JAL_R
10'b0000010000: begin Operand1_ACU_ID=Rout1; Operand2_ACU_ID=Immediate; Operand1_DEU_ID=0; Operand2_DEU_ID=Rout2; end          //S Type 
10'b0000001000: begin Operand1_ACU_ID=PC_ID; Operand2_ACU_ID=Immediate; Operand1_DEU_ID=Rout1; Operand2_DEU_ID=Rout2; end      //B Type 
10'b0000000100: begin Operand1_ACU_ID=0; Operand2_ACU_ID=0; Operand1_DEU_ID=0; Operand2_DEU_ID=Immediate; end      //U Type LUI
10'b0000000010: begin Operand1_ACU_ID=0; Operand2_ACU_ID=0; Operand1_DEU_ID=PC_ID; Operand2_DEU_ID=Immediate; end      //U Type AUIPC 
10'b0000000001: begin Operand1_ACU_ID=PC_ID; Operand2_ACU_ID=Immediate; Operand1_DEU_ID=PC_ID; Operand2_DEU_ID=32'h0000_0004; end      //J Type JAL
default: begin Operand1_ACU_ID=0; Operand2_ACU_ID=0; Operand1_DEU_ID=0; Operand2_DEU_ID=0; end                          //default all zero
endcase
end
//===============================================================================================================================

//=============================================== Data Execution Unit Control ===================================================
always@(*) begin
case ({R_Type, I_Type_Arithmetic, I_Type_Shift, I_Type_Load, S_Type, B_Type, U_Type_LUI, U_Type_AUIPC, J_Type, I_Type_JAL_R})
10'b1000000000: begin Alu_Cntrl_ID = {{1'b0},IR[30],IR[14:12]}; end      //R Type
10'b0110000000: begin Alu_Cntrl_ID = {{1'b0},IR[30],IR[14:12]}; end      //I Type Shift
10'b0100000000: begin Alu_Cntrl_ID = {{1'b0},{1'b0},IR[14:12]}; end      //I Type Arithmetic
10'b0001000000: begin Alu_Cntrl_ID = 5'b00000;end                        //I_Type_Load
10'b0000100000: begin Alu_Cntrl_ID = 5'b00000;end                        //S_Type
10'b0000010000: begin Alu_Cntrl_ID = {{1'b1},{1'b0},IR[14:12]};end       //B_Type
10'b0000001000: Alu_Cntrl_ID = 5'b00000;                                 //U_Type_LUI
10'b0000000100: Alu_Cntrl_ID = 5'b00000;                                 //U_Type_AUIPC
10'b0000000010: Alu_Cntrl_ID = 5'b00000;                                 //J_Type_JAL
10'b0000000001: Alu_Cntrl_ID = 5'b00000;                                 //I_Type_JAL_R
default: Alu_Cntrl_ID = 5'b00000;
endcase
end
//===============================================================================================================================
//=============================================== WriteBack Unit Control ========================================================
assign Write_Enable_ID = (R_Type||I_Type_Arithmetic||I_Type_Load||U_Type_LUI||U_Type_AUIPC||J_Type||I_Type_JAL_R); //Destination Register Valid
assign Rs1_Valid_ID = (R_Type||I_Type_Arithmetic||I_Type_Load||S_Type||B_Type||I_Type_JAL_R); //Source Register 1 Valid
assign Rs2_Valid_ID = (R_Type||S_Type||B_Type); //Source Register 2 Valid
assign Immediate_Format_ID = {I_Type_Load, S_Type, B_Type, U_Type_LUI, U_Type_AUIPC, J_Type, I_Type_JAL_R};
//===============================================================================================================================
//=============================================== MUX ========================================================
always@(*)
if (MUX_ID_PM) begin
//For ID-EX Pipeline for Control and Data Hazard
Operand1_ACU_ID_PM = 0; //Operand 1 to Address ALU
Operand2_ACU_ID_PM = 0; //Operand 2 to Data ALU
Operand1_DEU_ID_PM = 0; //Operand 1 to Data ALU
Operand2_DEU_ID_PM = 0; //Operand 2 to Address ALU
Alu_Cntrl_ID_PM = 0;
rs1_ID_PM = 0;
rs2_ID_PM = 0;
Func3_ID_PM = 0;
Immediate_Format_ID_PM = 0; //I_Type_Load, S_Type, B_Type, U_Type_LUI, U_Type_AUIPC, J_Type, I_Type_JAL_R
rd_ID_PM = 0;   //Address of rd
Rs1_Valid_ID_PM = 1;
Rs2_Valid_ID_PM = 1;
Write_Enable_ID_PM = 1;
end
else begin
//For ID-EX Pipeline Normal Operation
Operand1_ACU_ID_PM = Operand1_ACU_ID; //Operand 1 to Address ALU
Operand2_ACU_ID_PM = Operand2_ACU_ID; //Operand 2 to Data ALU
Operand1_DEU_ID_PM = Operand1_DEU_ID; //Operand 1 to Data ALU
Operand2_DEU_ID_PM = Operand2_DEU_ID; //Operand 2 to Address ALU
Alu_Cntrl_ID_PM = Alu_Cntrl_ID;
rs1_ID_PM = rs1_ID;
rs2_ID_PM = rs2_ID;
Func3_ID_PM = Func3_ID;
Immediate_Format_ID_PM = Immediate_Format_ID; //I_Type_Load, S_Type, B_Type, U_Type_LUI, U_Type_AUIPC, J_Type, I_Type_JAL_R
rd_ID_PM = rd_ID;   //Address of rd
Rs1_Valid_ID_PM = Rs1_Valid_ID;
Rs2_Valid_ID_PM = Rs2_Valid_ID;
Write_Enable_ID_PM = Write_Enable_ID;
end


//===============================================================================================================================
/*always@(*)
begin
$display("\n Stage 2");
$display("PC_ID: %b",PC_ID);
$display("Immediate_Format_ID: %b",Immediate_Format_ID);
$display("Immediate: %d",Immediate);
$display("Alu_Cntrl_ID: %b",Alu_Cntrl_ID);
$display("I_Type_Load: %b ",I_Type_Load);
$display("rs1_ID: %d ",rs1_ID);
$display("rs2_ID: %d ",rs2_ID);
$display("rd_ID: %d ",rd_ID);
$display("Func3_ID: %b ",Func3_ID);
$display("Operand1_ACU_ID: %b ",Operand1_ACU_ID);
$display("Operand2_ACU_ID: %b ",Operand2_ACU_ID);
$display("Operand1_DEU_ID: %b ",Operand1_DEU_ID);
$display("Operand2_DEU_ID: %b ",Operand2_DEU_ID);
end*/
endmodule
