/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Processor.v
*	Purpose: Holding for all processor Componenets
*
*
*/

`include "Integration_1.v"
`include "Stage_1.v"
`include "Integration_2.v"
`include "APB.v"

module Processor(	input	clk,
				rst
		);


	wire 		memenable; // Used to prepare APB Data Memory
	wire 		memselect; // Used to Read or allow Write APB Memory
	wire 		memwrite;  // Used to allow Write APB Memory

	wire[31:0] 	exInst_1;

	wire[31:0]	PCNI_1;
	wire[7:0] 	jtarget_1;
	wire[7:0] 	idata_1;
	wire[5:0] 	memaddr_1;
	wire[4:0] 	boffset_1;
	wire[2:0]	funct_1;
	wire[2:0]	ALUfunct_1;
	wire[1:0]	op_1;
	wire		Mmuxout_1;
	wire		regWrite_1;
	wire[1:0] 	shamt_1;
	wire[31:0]	PC_1;	
	wire		jmp_1;
	wire		bne_1;
	wire		memRead_1;
	wire		memWrite_1;
	wire		valid_1;
	wire[15:0] 	reg1data_1;	
	wire[15:0]	reg2data_1;
	wire[2:0] 	ALU_func_1;
	wire[6:0] 	iVal_1;

	// Below Here should be internal
	wire[15:0]	mem_data_1;	
	wire		write_reg_1;


	wire[31:0] 	exInst_2;
	wire[31:0]	PCNI;
	wire[7:0] 	jtarget_2;
	wire[7:0] 	idata_2;
	wire[5:0] 	memaddr_2;
	wire[4:0] 	boffset_2;
	wire[2:0]	funct_2;
	wire[2:0]	ALUfunct_2;
	wire[1:0]	op_2;
	wire		Mmuxout_2;
	wire		regwrite;
	wire[1:0] 	shamt_2;
	wire[31:0]	PC_2;	
	wire		jmp_2;
	wire		bne_2;
	wire		memRead_2;
	wire		memWrite_2;
	wire		valid_2;
	wire[15:0] 	reg1data_2;	
	wire[15:0]	reg2data_2;
	wire[2:0] 	ALU_func_2;
	wire[6:0] 	iVal_2;

	wire[15:0]	mmuxout;
	wire[15:0]	memdata;
	// Below Here should be internal
	wire[15:0]	mem_data_2;	
	wire		write_2;
	wire		write_reg_2;

	Integration1	I1( 	
			.clk(clk),
			.rst(rst),
			//.exInst(exInst),
			.PCNI(PCNI),
			.mmuxout(mmuxout),
			.regwrite(regwrite),
                                  
			.shamt(shamt_1),
			.op(op_1),
                                  
			.PC(PC_1),	
			.jmp(jmp_1),
			.idata(idata_1),	// immediate data from instruction
			.bne(bne_1),
			.memRead(memread_1),
			.memWrite(memwrite_1),
			.valid(valid_1),
		     	.reg1data(reg1data_1),	// Removing From Pipeline. Bad
			.reg2data(reg2data_1), // Removing From Pipeline. Bad
		      	.ALU_func(ALU_func_1),
			.func(funct_1),
			.boff(boffset_1),
                                  
			.mem_data(mem_data_1),	
			.write_reg(write_reg_1)
		);

		Stage1 	S1( 
			.clk(clk),
			.rst(rst),

			.reg1data_in(reg1data_1),	// Register 1 data	
			.reg2data_in(reg2data_1),	// Register 2 data	
			.jtarget_in(idata_1),	// Target to jump to 
			.idata_in(idata_1),	// immediate data from instruction
			.memaddr_in( idata_1),	// Memory address
			.boffset_in( boffset_1),	// Branch Offset
			.funct_in(funct_1),	// function code
			.shamt_in(shamt_1),
			.op_in(op_1),	
			.jmp_in(jmp_1),	
			.bne_in(bne_1),	
			.memread_in(memread_1),	
			.memwrite_in(memwrite_1),	
			.ALUfunct_in(ALUfunct_1),	// ALU function Code
			.jr_in(jr_1),		// jump register?  - as of 9/8/16 I have forgot what this is supposed to do...
	        	.PC_in(PC_1),
                                     
			.reg1data_out(reg1data_2),	// Register 1 data	
			.reg2data_out(reg2data_2),	// Register 2 data	
			.jtarget_out(jtarget_2),	// Target to jump to 
			.idata_out(idata_2),	// immediate data from instruction
			.memaddr_out(memaddr_2),	// Memory address
			.boffset_out(boffset_2),	// Branch Offset
			.funct_out(funct_2),	// function code
			.shamt_out(shamt_2),
			.op_out(op_2),	
			.jmp_out(jmp_2),	
			.bne_out(bne_2),	
			.memread_out(memread_2),	
			.memwrite_out(memwrite_2),	
			.ALUfunct_out(ALUfunct_2),	// ALU function Code
			.jr_out(jr_2),		// jump register?  - as of 9/8/16 I have forgot what this is supposed to do...
	        	.PC_out(PC_2)
	  );

	assign memenable = ~(memread_1 | memwrite_1 );
	assign memselect = (memread_2 | memwrite_1 | memwrite_2);
	assign memwrite  = (memwrite_1 | memwrite_2);

	Integration2	I2(
			.clk(clk),
			.rst(rst),

			//.reg1data_in(reg1data_2),	// Register 1 data	
			//.reg2data_in(reg2data_2),	// Register 2 data	
			.reg1data_in(reg1data_1),	// Register 1 data	
			.reg2data_in(reg2data_1),	// Register 2 data	
			.jtarget_in(jtarget_2),	// Target to jump to 
			.idata_in(idata_2),	// immediate data from instruction
			.memaddr_in(memaddr_2),	// Memory address
			.boffset_in(boffset_2),	// Branch Offset
			.funct_in(funct_2),	// function code
			.op_in(op_2),		// Operation type
			.shamt_in(shamt_2),	// Shift Amount in
			.bne_in(bne_2),		// Branch Flag 
			.jr_in(jr_2),		// jump register?  - as of 9/8/16 I have forgot what this is supposed to do...
			.jmp(jmp_2),
			.memread(memread_2),	// Memory Read Flag
			.memwrite(memwrite_2),	// Memory Write Flag
			.memenable(memenable),
			.memselect(memselect),
			.datamemwrite(memwrite),
			.PC_in(PC_2),		// Program Counter from Pipeline


			.mmuxout(mmuxout),	// data from either memory or ALU
			.regwrite(regwrite),
			.PC_out(PCNI)

	  );
endmodule
