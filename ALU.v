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
		input[7:0]		idata,		// Immediate Data from Inst
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
	parameter	LUI	= 5'b01_000;
	parameter	LBI	= 5'b01_001;
	parameter	SUI	= 5'b01_010;
	parameter	SBI	= 5'b01_011;

	always @(*)
	begin
		case ({op,funct})
			NAND:	ALUout = (~(reg1data & reg2data) << shamt);
			XOR:	ALUout = ((reg1data ^  reg2data) << shamt);
			SLL:	ALUout = ((reg1data << reg2data) << shamt); 
			SRL:	ALUout = ((reg1data >> reg2data) << shamt); 
			SRA:	ALUout = ((reg1data >>> reg2data) << shamt); 
			ADD:	ALUout = ((reg1data +  reg2data) << shamt);
			SUB:	ALUout = ((reg1data -  reg2data) << shamt);
			LUI:	ALUout = ({idata, 8'b0000_0000});
			LBI:	ALUout = ({8'b0000_0000, idata});
			SUI:	ALUout = ({idata, 8'b0000_0000});
			SBI:	ALUout = ({8'b0000_0000, idata});
			default:ALUout = 16'bxxxx_xxxx_xxxx_xxxx; // don't care...not zero. This will save space
		endcase

	end
endmodule
