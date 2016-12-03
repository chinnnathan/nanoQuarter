/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  PC Next Instruction Mux
*	Inputs:  jump addr, jump, Branch Sel
*	Outputs: PC next instruction
*	
*/

module PCNIMUX(	input[15:0]		jaddr,  // Jump address
		input[31:0]		bsel,	// Program Counter from Branch Selection
		input			jmp,	// Jump Flag
		output reg[31:0]	PCNI	// Next Instruction Program Counter	
	  );

	always @(*)
	begin
		if (jmp == 1)
			PCNI = bsel + jaddr;	
		else
			PCNI = bsel;
	end
endmodule
