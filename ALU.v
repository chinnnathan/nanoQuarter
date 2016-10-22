/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  ALU
*	Inputs:  reg1data, reg2data, ALU function, Shift Amount,
*		 op code
*	Outputs: Bsel PC after branch selection
*	Note: 	 Only deals with i type and r-type instructions
*	
*/

module ALU(	input[1:0]		op,    		// Operation Code for decode
		input[15:0]		memdata,	// Data from Memory
		input[2:0]		funct,		// Function Code
		input[1:0]		shamt,		// Shift Amount
		output reg[15:0]	ALUout,		// Data from ALU
		input[15:0]		reg1data,	// Registerr Data
					reg2data	// Registerr Data
	  );

	parameter	NAND	= 5'b00_000;
	parameter	XOR 	= 5'b00_001;
	parameter	SLL 	= 5'b00_010;
	parameter	SRL 	= 5'b00_011;
	parameter	SRA 	= 5'b00_100;
	parameter	ADD 	= 5'b00_101;
	parameter	SUB 	= 5'b00_110;

	always @(*)
	begin
		case ({op,funct})
			NAND:	ALUout = ~(reg1data & reg2data); 
			XOR:	ALUout = (reg1data ^  reg2data);
			SLL:	ALUout = (reg1data << reg2data);
			SRL:	ALUout = (reg1data >> reg2data);
			SRA:	ALUout = (reg1data >> reg2data);
			ADD:	ALUout = (reg1data +  reg2data);
			SUB:	ALUout = (reg1data -  reg2data);
			default:ALUout = 0;
		endcase

	end
endmodule
