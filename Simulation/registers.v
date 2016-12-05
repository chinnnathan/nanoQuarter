
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
			input			write_reg,	 // Write Protect Bar (1 means write ok)

			output reg[15:0]	reg1data,
						reg2data
		);

		reg [15:0] registers[7:0]; // 8 16 bit registers
		reg [2:0] rd_last; // last destination register
		
		integer index = 0;
		

		always @ (posedge clk or posedge rst)
		begin
			if (rst == 1)
			begin
				rd_last <= 0;
				for( index=0; index<=7; index = index + 1)
				begin
					registers[index] <= 16'b0000_0000_0000_0000;
			end	
			end
			else
			begin
				if (write_reg == 1)
				begin
					registers[rd_last] <= data_in;
				end
				rd_last <= rd;

				reg1data <= registers[rs1]; // pass through
				reg2data <= registers[rs2]; // pass through
			end
		end



endmodule
			
