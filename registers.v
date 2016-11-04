
/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Registers Module
*	Inputs:  register source 1, register source 2
*		 register destination, Data in, Write Protect Bar
*	Outputs: register 1 data, register 2 data
*
*/

module Registers(	input 			clk,	 // System Clock
						rst,	 // System Reset
			input[2:0] 		rs1,	 // register source 1
						rs2,	 // register source 2
						rd,	 // register destination
			input[15:0]		data_in, // data to be writen to rd
			input			wp,	 // Write Protect Bar (1 means write ok)

			output wire[15:0]	reg1data,
						reg2data
		);

		reg [2:0] registers[15:0]; // 8 16 bit registers
		reg [3:0] rd_last; // last destination register
		
		assign reg1data = registers[rs1]; // pass through
		assign reg2data = registers[rs2]; // pass through

		always @ (posedge clk)
		begin
			if (wp == 1)
				registers[rd_last] = data_in;
			rd_last = rd;
		end


endmodule
			
