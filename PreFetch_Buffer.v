/*
* 	Nathan Chinn Edited by Bryan Lee
* 	Minion CPU - NanoQuarter
*
*	Module:  Pre-Fetch Buffer
*	Inputs:  instruction 1, instruction 2, write protect bar
*	Outputs: instruction
*	
*	Note: This works to solve a 1 clock cycle latency in APB
*/

module PrefetchBuffer(	input 			clk, 	// System Clock
						rst, 	// System Reset
			input[15:0]		inst1,	// Instruction 1
			input[15:0]		inst2,	// Instruction 2
			input			write,	// Write Protect Bar
			input			stall_flg,

			output reg[15:0]	inst	// function	
	  );

	reg[15:0]	inst_mem;
	
	always @(posedge clk)
	begin
		if(write === 1 && !stall_flg)
		begin 
			inst		<= inst1;
			inst_mem 	<= inst2;
		end
		else
			inst	<= inst_mem;
	end
endmodule
