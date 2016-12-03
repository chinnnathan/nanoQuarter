/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Stall Unit
*	Inputs:  opcode, register source 1, register source 2, register
*		 destination, program counter
*	Outputs: stall flag, Program counter
*
*/

module StallUnit(	input		clk,	// System Clock
					rst, 	// System Reset
			input[1:0]	opcode,	// operation code
			input[2:0]	rs1,	// register source 1
					rs2,	// register source 2
					rd,	// register destination
			input[31:0]	pc_old,	// program counter in
			output reg		stall_flg // Flag set high when stall required
		);
	reg[2:0] rd_last;
	reg	 clear_stall;

	always @ (posedge clk or posedge rst) //non blocking statements added
	begin
		if(rst == 1)
		begin
			clear_stall <= 0;
			rd_last <= 3'b000;
		end

		else
		begin
			stall_flg <= 0;
			
			if(clear_stall == 0)
			begin
				if(rd_last == rs1 || rd_last == rs2)
				begin
					stall_flg <= 1;
					clear_stall <= 1;
				end
			end
			else
			begin
				stall_flg <= 0;
				clear_stall <= 0;
			end

			rd_last <= rd;
		end
	end
endmodule
			
