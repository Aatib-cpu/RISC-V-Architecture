`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2024 02:16:17 AM
// Design Name: 
// Module Name: Stage_4
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

module Stage_4(
input Clk, Reset, Is_Load, Is_Store, Mem_Enable,
input [2:0] Variant,
input [31:0] Mem_Address_Reg,       //Address_Mem
input [31:0] Mem_Data_Reg,          //Alu_Out_Mem
output reg [31:0] Loaded_Data_MEM
);

reg [7:0] Mem [0 : 127];
integer i;

initial
for (i=0;i<128;i=i+1)
		Mem [i] = i;

always@(Reset,Is_Load,Mem_Address_Reg,Variant) begin
/*if (Reset)
	for (i=0;i<128;i=i+1)
		Mem [i] = 0;
		
else*/ if ({Is_Load,Is_Store} == 2'b10)
	case (Variant)
		3'b000: Loaded_Data_MEM = {{24{Mem[Mem_Address_Reg[6:0]][7]}},Mem[Mem_Address_Reg[6:0]]};  	    //lb
		3'b001: Loaded_Data_MEM = {{16{Mem[Mem_Address_Reg[6:0]+1][7]}},Mem[Mem_Address_Reg[6:0]+1],Mem[Mem_Address_Reg[6:0]]};	    //lh
		3'b010: Loaded_Data_MEM = {Mem[Mem_Address_Reg[6:0]+3],Mem[Mem_Address_Reg[6:0]+2],Mem[Mem_Address_Reg[6:0]+1],Mem[Mem_Address_Reg[6:0]]};					                //lw
		3'b100: Loaded_Data_MEM = {{24{1'b0}},Mem[Mem_Address_Reg[6:0]]};			    //lbu
		3'b101: Loaded_Data_MEM = {{16{1'b0}},Mem[Mem_Address_Reg[6:0]+1],Mem[Mem_Address_Reg[6:0]]};			    //lhu
		//default:  Loaded_Data_MEM = 0;	
	endcase
end

always@(posedge Clk)
if ({Is_Load,Is_Store} == 2'b01) 
	case (Variant)
		3'b000: Mem[Mem_Address_Reg[6:0]] = Mem_Data_Reg[7:0];  	//sb
		3'b001: {Mem[Mem_Address_Reg[6:0]+1],Mem[Mem_Address_Reg[6:0]]} = Mem_Data_Reg[15:0];	//sh
		3'b010: {Mem[Mem_Address_Reg[6:0]+3],Mem[Mem_Address_Reg[6:0]+2],Mem[Mem_Address_Reg[6:0]+1],Mem[Mem_Address_Reg[6:0]]} = Mem_Data_Reg;					                //sw
		//default:  Store_Data = Mem_Data_Reg;
	endcase
	
   always@(*)
    begin
    $display("\n Stage 4");
    $display("Is_Load: %b",Is_Load);
    $display("Is_Store: %b",Is_Store);
    $display("Mem_Enable: %b",Mem_Enable);
    $display("Variant: %b ",Variant);
    $display("Mem_Address_Reg: %d ",Mem_Address_Reg);
    $display("Mem_Data_Reg: %d ",Mem_Data_Reg);
    $display("Loaded_Data_MEM: %h ",Loaded_Data_MEM);
    end 
    always@(Mem) 
        for (i=0;i<128;i=i+1) 
            $display("Mem[%0d] = %0d",i,Mem[i]);  //Displaying modified Register File 
              
    endmodule


/*always@(Reset, Is_Load, Is_Store)
 
if (Reset)
	for (i=0;i<128;i=i+1)
		Mem [i] = i;
		
else
    if ({Is_Load,Is_Store} == 2'b10)
	   case (Variant)
		000: Loaded_Data_MEM = {{24{Mem_Address_Reg[6]}},Mem[Mem_Address_Reg[6:0]]};  	    //lb
		001: begin                                                                            //lh
		      if (Mem_Address_Reg[6:0]==7'd127)
		          Loaded_Data_MEM = {{16{Mem_Address_Reg[6]}},Mem[Mem_Address_Reg[6:0]],Mem[0]};
		      else
		          Loaded_Data_MEM = {{16{Mem_Address_Reg[6]}},Mem[Mem_Address_Reg[6:0]],Mem[Mem_Address_Reg[6:0]+1]};	
		     end    
		010: begin                                                                                    //lw
		      if (Mem_Address_Reg[6:0]==7'd125)
		          Loaded_Data_MEM = {Mem[Mem_Address_Reg[6:0]],Mem[Mem_Address_Reg[6:0]+1],Mem[Mem_Address_Reg[6:0]+2],Mem[0]};
		      else if (Mem_Address_Reg[6:0]==7'd126)
		          Loaded_Data_MEM = {Mem[Mem_Address_Reg[6:0]],Mem[Mem_Address_Reg[6:0]+1],Mem[0],Mem[1]};
		      else if (Mem_Address_Reg[6:0]==7'd127)
		          Loaded_Data_MEM = {Mem[Mem_Address_Reg[6:0]],Mem[0],Mem[1],Mem[2]};
		      else
		          Loaded_Data_MEM = {Mem[Mem_Address_Reg[6:0]],Mem[Mem_Address_Reg[6:0]+1],Mem[Mem_Address_Reg[6:0]+2],Mem[Mem_Address_Reg[6:0]+3]};	
		     end   					                
		100: Loaded_Data_MEM = {{24{1'b0}},Mem[Mem_Address_Reg[6:0]]};                          //lbu
		101:  begin //lhu
                if (Mem_Address_Reg[6:0]==7'd127)
                    Loaded_Data_MEM = {{16{1'b0}},Mem[Mem_Address_Reg[6:0]],Mem[0]};
                else
                    Loaded_Data_MEM = {{16{1'b0}},Mem[Mem_Address_Reg[6:0]],Mem[Mem_Address_Reg[6:0]+1]};	
              end    
		default:  Loaded_Data_MEM = 0;	
	   endcase
	   
    else if ({Is_Load,Is_Store} == 2'b01)       
	   case (Variant)
		000: Mem[Mem_Address_Reg[6:0]] = Mem_Data_Reg[7:0];  	            //sb
		001:  begin                                                       //sh
                if (Mem_Address_Reg[6:0]==7'd127)
		          {Mem[Mem_Address_Reg[6:0]],Mem[0]} = Mem_Data_Reg[15:0];
                else	
		          {Mem[Mem_Address_Reg[6:0]],Mem[Mem_Address_Reg[6:0]+1]} = Mem_Data_Reg[15:0];
		      end
		010: begin                                                  //sw
		      if (Mem_Address_Reg[6:0]==7'd125)
		          {Mem[Mem_Address_Reg[6:0]],Mem[Mem_Address_Reg[6:0]+1],Mem[Mem_Address_Reg[6:0]+2],Mem[0]} = Mem_Data_Reg;
		      else if (Mem_Address_Reg[6:0]==7'd126)
		          {Mem[Mem_Address_Reg[6:0]],Mem[Mem_Address_Reg[6:0]+1],Mem[0],Mem[1]} = Mem_Data_Reg;
		      else if (Mem_Address_Reg[6:0]==7'd127)
		          {Mem[Mem_Address_Reg[6:0]],Mem[0],Mem[1],Mem[2]} = Mem_Data_Reg;
		      else
		          {Mem[Mem_Address_Reg[6:0]],Mem[Mem_Address_Reg[6:0]+1],Mem[Mem_Address_Reg[6:0]+2],Mem[Mem_Address_Reg[6:0]+3]} = Mem_Data_Reg;
             end					
	   endcase
	   
	 else
	   Loaded_Data_MEM = 0;

endmodule*/

