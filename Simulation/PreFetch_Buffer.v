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
			input[31:0]		PC_in,
			output reg		enable,
			output reg		read,
			output reg[31:0]	PC_out,

			output reg[15:0]	inst	// function	
	  );

	reg[15:0]	inst_mem;
	
	always @(posedge clk or posedge rst)
	begin
		if( rst == 1)
		begin
			enable <= 1;
			read   <= 1;
		end
		else
		begin
			enable <= ~enable;
			if(write === 1)
			begin 

				if (stall_flg == 1)
					begin
						inst_mem <= inst;
					end
					else
					begin
						inst 		<= inst1;
						PC_out		<= PC_in;
						inst_mem	<= inst2;
					end
			end
			else
				if (stall_flg == 1)
				begin
					;
				end
				else
				begin
					inst	<= inst_mem;
				end
		end
	end
endmodule
