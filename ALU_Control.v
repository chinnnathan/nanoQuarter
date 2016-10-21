/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  ALU
*	Inputs:  instruction
*	Outputs: function code, shift amount, jump register
*
*/

module ALUControl(	input[15:0]	inst,	// Instruction
			output reg[2:0]	func,	// function	
			output reg[1:0]	shamt,	// shift amount
			output reg	jr	// jump register?  - as of 9/8/16 I have forgot what this is supposed to do...
	  );
	parameter rType = 2'b00;
	parameter iType = 2'b01;
	parameter jType = 2'b10;

	always @(*) // all statements need to be non-blocking <= because of always @(*)
	begin
		func = inst[2:0];
		if (inst[15:14] == rType || inst[15:14] == iType)
			shamt = inst[4:3];
		else
			shamt = 2'b00;
	//end 
	//begin
		if (inst[15:14] == jType)
			jr = 1'b1;	
		else
			jr = 1'b0;	
			
	end
endmodule
