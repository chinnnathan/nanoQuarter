/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Program Counter
*	Inputs:  clock, reset, new PC
*	Outputs: Program Counter
*
*/

module PC( input 		clk, // System Clock
		 		rst, // System Reset
	   input[31:0] 		new_PC, // PC in 

	   output reg[31:0] 	PC_out //PC out
	 );

	 always @ (posedge clk or posedge rst) //needs non blocking <=
	 begin
	 	if(rst == 1'b1)
			PC_out <= 0;
		else
			PC_out <= new_PC;
	 end

endmodule
