`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2024 07:14:31 AM
// Design Name: 
// Module Name: Stage_3
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


module Stage_3(
input [31:0] PC_EX,
input [31:0] Operand1_ACU_EX_Fwd, //Operand 1 to Address ALU
input [31:0] Operand2_ACU_EX, //Operand 2 to Data ALU
input [31:0] Operand1_DEU_EX_Fwd, //Operand 1 to Data ALU
input [31:0] Operand2_DEU_EX_Fwd, //Operand 2 to Address ALU
input [4:0] Alu_Ctrl_EX,			//ALU Control from controller
input J_Type_EX,
input I_Type_JAL_R_EX,
output reg [31:0] Address_EX,
output reg Is_Branch_Taken,     //Branch Comparator Result
output reg [31:0] Alu_Out_EX		//Output of ALU
);

//Intermediate Varriables;      
reg signed [31:0] Sign_Op1, Sign_Op2, Sign_Op1_ACU, Sign_Op2_ACU;
reg signed [31:0] Address;
always@(*)
	 begin
        //Initializing Values
	Is_Branch_Taken = 0;
	Alu_Out_EX = 0;
        Sign_Op1 = Operand1_DEU_EX_Fwd; Sign_Op2 = Operand2_DEU_EX_Fwd;
        Sign_Op1_ACU = Operand1_ACU_EX_Fwd; Sign_Op2_ACU = Operand2_ACU_EX;
        
        //Branch Address or Memory Address Calculation
        Address = Sign_Op1_ACU + Sign_Op2_ACU;
        Address_EX = (I_Type_JAL_R_EX?(Address&(32'hFFFFE)):(Address));
        
	case (Alu_Ctrl_EX)
		5'b00000: Alu_Out_EX = Sign_Op1 + Sign_Op2;				//R_Type I_Type ADD  //S Type 
        	5'b01000: Alu_Out_EX = Sign_Op1 + (~Sign_Op2) + 1;			//R_Type I_Type SUB
		5'b00001: Alu_Out_EX = Operand1_DEU_EX_Fwd << Operand2_DEU_EX_Fwd[4:0];	//R_Type I_Type SLL
		5'b00010: Alu_Out_EX = (Sign_Op1<Sign_Op2)?1:0;                        	//R_Type I_Type SLT Set Less Than
		5'b00011: Alu_Out_EX = (Operand1_DEU_EX_Fwd<Operand2_DEU_EX_Fwd)?1:0;	//R_type I_Type SLTU Set Less Than Unsigned
		5'b00100: Alu_Out_EX = Operand1_DEU_EX_Fwd^Operand2_DEU_EX_Fwd;							          //R_Type I_Type XOR
		5'b00101: Alu_Out_EX = Operand1_DEU_EX_Fwd >> Operand2_DEU_EX_Fwd[4:0];    						  //R_Type I_Type SRL
		5'b01101: Alu_Out_EX = Sign_Op1 >>> Operand2_DEU_EX_Fwd[4:0];								  //R_Type I_Type SRA
		5'b00110: Alu_Out_EX = Operand1_DEU_EX_Fwd | Operand2_DEU_EX_Fwd;						          //R_Type I_Type OR
		5'b00111: Alu_Out_EX = Operand1_DEU_EX_Fwd & Operand2_DEU_EX_Fwd;						          //R_Type I_Type AND
		
		//B Type (Branching)
		5'b10000: Is_Branch_Taken = (Sign_Op1==Sign_Op2);                	//beq
		5'b10001: Is_Branch_Taken = (Sign_Op1!=Sign_Op2);                	//bne
		5'b10100: Is_Branch_Taken = (Sign_Op1<Sign_Op2);                 	//blt
		5'b10101: Is_Branch_Taken = ((Sign_Op1>=Sign_Op2));              	//bge 
		5'b10110: Is_Branch_Taken = (Operand1_DEU_EX_Fwd<Operand2_DEU_EX_Fwd);	//bltu
		5'b10111: Is_Branch_Taken = (Operand1_DEU_EX_Fwd>=Operand2_DEU_EX_Fwd);	//bgeu
		default : Is_Branch_Taken = I_Type_JAL_R_EX||J_Type_EX;
	endcase    
	end
	
/*always@(*) begin
$display("\n Stage 3");
$display("PC_EX: %b",PC_EX);
$display("Operand1_ACU_EX_Fwd: %d ",Operand1_ACU_EX_Fwd);
$display("Operand2_ACU_EX: %d ",Operand2_ACU_EX);
$display("Operand1_DEU: %d ",Operand1_DEU_EX_Fwd);
$display("Operand2_DEU: %d ",Operand2_DEU_EX_Fwd);
$display("Sign_Op1_ACU: %d ",Sign_Op1_ACU);
$display("Sign_Op2_ACU: %d ",Sign_Op2_ACU);
$display("Address: %d",Address);
$display("Address_EX: %d",Address_EX);
$display("Alu_Out_EX: %d",Alu_Out_EX);
$display("Is_Branch_Taken: %b",Is_Branch_Taken);
end   */

endmodule
