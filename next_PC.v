/*
* 	Bryan Lee
* 	Minion CPU - NanoQuarter
*
*	Module:  next Program Counter
*	Inputs:  PC
*	Outputs: next_PC which is PC + 4
*
*/
module next_PC(	input [31:0] PC,
				output [31:0] next_PC);
	assign next_PC = PC + 4;
endmodule
