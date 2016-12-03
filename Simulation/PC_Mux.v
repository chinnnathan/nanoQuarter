/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  PC Mux
*	Inputs:  PC, PC Next Instruction, Stall flag
*	Outputs: PC 
*	
*/

module PCMUX(	input[31:0]		PC_in,  	// Same Program Count
		input[31:0]		PCNI,		// Program Counter from Branch Selection
		input			stall_flg,	// Stall Flag
		output reg[31:0]	PC_out		// Next Instruction Program Counter	
	  );

	always @(*)
	begin
		if (stall_flg == 1)
			PC_out = PC_in;
		else
			PC_out = PCNI;
	end
endmodule
