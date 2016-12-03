/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Stage1.v
*	Purpose: Stalls all necessary data 1 clock cycle
*
*
*/

module Stage1( input 			clk,
			 		rst,

		input[15:0]		reg1data_in,	// Register 1 data	
			       		reg2data_in,	// Register 2 data	
		input[7:0]		jtarget_in,	// Target to jump to 
		input[7:0]		idata_in,	// Immediate Data
		input[5:0]		memaddr_in,	// Memory address
		input[4:0]		boffset_in,	// Branch Offset
		input[2:0]		funct_in,	// function code
		input[2:0]		ALUfunct_in,	// ALU function Code
		input[1:0]		op_in,		// operation code
		input[1:0]		shamt_in,	// Shift amount code
		input			jr_in,		// jump register?  - as of 9/8/16 I have forgot what this is supposed to do...
		input			jmp_in,
		input			bne_in,
		input			memread_in,
		input			memwrite_in,
	        input[31:0]		PC_in,

		output reg[15:0]	reg1data_out,	// Register 1 data	
		       			reg2data_out,	// Register 2 data	
		output reg[7:0]		jtarget_out,	// Target to jump to 
		output reg[7:0]		idata_out,	// Immediate Data
		output reg[5:0]		memaddr_out,	// Memory address
		output reg[4:0]		boffset_out,	// Branch Offset
		output reg[2:0]		funct_out,	// function code
		output reg[2:0]		ALUfunct_out,	// ALU function Code
		output reg[1:0]		op_out,		// operation code
		output reg[1:0]		shamt_out,	// Shift Amount code
		output reg		jr_out,		// jump register?  - as of 9/8/16 I have forgot what this is supposed to do...
		output reg		jmp_out,
		output reg		bne_out,
		output reg		memread_out,
		output reg		memwrite_out,
	        output reg[31:0]	PC_out
	  );

	always @(posedge clk) 
	begin
		reg1data_out 	<= reg1data_in;
		reg2data_out 	<= reg2data_in;
		jtarget_out  	<= jtarget_in;
		memaddr_out  	<= memaddr_in;
		boffset_out  	<= boffset_in;
		funct_out    	<= funct_in;
		op_out    	<= op_in;
		ALUfunct_out 	<= ALUfunct_in;
		shamt_out    	<= shamt_in;
		jr_out 	     	<= jr_in;
		jmp_out		<= jmp_in;
		bne_out		<= bne_in;
		memread_out	<= memread_in;
		memwrite_out	<= memwrite_in;
		PC_out	     	<= PC_in;
		idata_out	<= idata_in;
	end

	always @(posedge rst)
	begin
		PC_out		<= 0;
	end
endmodule
