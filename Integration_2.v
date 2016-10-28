
/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Integration_2.v
*	Purpose: Second stage of the integration Pipeline
*
*
*/
`include "Jump_Calc.v"
`include "branch_add.v"
`include "PC_NI_MUX.v"
`include "ALU.v"
module Integration2( 	input 			clk,
			 			rst,

			input[15:0]		reg1data_in,	// Register 1 data	
						reg2data_in,	// Register 2 data	
			input[7:0]		jtarget_in,	// Target to jump to 
			input[5:0]		memaddr_in,	// Memory address
			input[4:0]		boffset_in,	// Branch Offset
			input[2:0]		funct_in,	// function code
			input[2:0]		ALUfunct_in,	// ALU function Code
			input[1:0]		op_in,		// Operation type
						shamt_in,	// Shift Amount in
			input			bne_in,		// Branch Flag 
			input			jr_in,		// jump register?  - as of 9/8/16 I have forgot what this is supposed to do...
			input[31:0]		PC_in,		// Program Counter from Pipeline

			input[15:0]		memdata		// for testing
	  );

	wire[15:0] jaddr; 	// Address to Jump with 
	wire[31:0] bsel;	// Address from the Branch Increase
	wire[31:0] PCNI;	// Next Program Counter
	wire[15:0] memedata;	// Data from memory address
	wire[15:0] ALUout;	// Data from the ALU
	wire[31:0] PC_n;

	JumpCalc	JC(	.reg1data(reg1data_in),	.jtarget(jtarget_in),
				.funct(funct_in),	.jaddr(jaddr)
			  );

	BranchAdd	BA(	.boff(boffset_in),	.PC_n(PC_n),
				.bne(bne_in),		.bsel(bsel)
			  );

	PCNIMUX		PM(	.jaddr(jaddr),		.bsel(bsel),
				.jmp(jmp),		.PCNI(PCNI)
			  );

	ALU		A(	.op(op_in),		.memdata(memdata),
				.funct(funct_in),	.shamt(shamt_in),
				.reg1data(reg1data_in), .reg2data(reg2data_in),
				.ALUout(ALUout)
			);

						
endmodule
