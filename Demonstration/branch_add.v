/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Branch Adder
*	Inputs:  Next PC, bne flag, branch offset
*	Outputs: Bsel PC after branch selection
*	
*/

module BranchAdd(	input[4:0]		boff,   // Jump address
		 	input[31:0]		PC_n,	// next Program Counter
			input			bne,	// branch Flag
			output reg[31:0]	bsel	// Next Instruction Program Counter	
	  );

	always @(*) 
	begin
		if (bne == 1)
			bsel = PC_n - 2 + boff;	
		else
			bsel = PC_n;
	end
endmodule
