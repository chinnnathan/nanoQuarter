/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Processor.v
*	Purpose: Holding for all processor Componenets
*
*
*/

module Faux_Inst(	input clk,
			input rst,
			input [15:0] addr,
			output [31:0]out_inst
		);
	reg [31:0] instructions[50:0]; // room for 50 hard coded instructions
	always @ (posedge clk or posedge rst)
	begin
		if (rst == 1)
		begin

		end
		else
	end
endmodule

