/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Integration 2
*	Inputs:  
*	Outputs: 
*
* 	Need to test: ALU output given all functions
* 			ALU output given shifting
* 			Jr_in sets PC_NI to jtarget_in
* 			Mmux out is either directly from ALU data, or memdata
* 			regWrite is high when r-type
*
*	Test Flow: note that register dest/source is n0t important
*		NAND r1, r2, r0, 00
*		XOR r1, r2, r0, 00
*		SLL r1, r2, r0, 00
*		SRL r1, r2, r0, 00
*		SRA r1, r2, r0, 00
*		ADD r1, r2, r0, 00
*		SUB r1, r2, r0, 00
*
*		SW   r1, 000001, 01
*		LW   r0, 010101, 10 
*		LB   r5, 111011, 01
*		SB   r6, 101010, 11
*
*		JR   r5, 00000000 
*		JMP  r0, 00000101
*		BNE  r1, r2, 01110 
*
*/

// iverilog -o working.vpp Integration_2_TB.v && vvp working.vpp && gtkwave Integration_2_TB.vcd
`include "Integration_2.v"

module Integration2_TB();
	reg 		clk;
	reg		rst;
	reg[15:0]	reg1data_in;	// Register 1 data	
	reg[15:0]	reg2data_in;	// Register 2 data	
	reg[7:0]	jtarget_in;	// Target to jump to 
	reg[5:0]	memaddr_in;	// Memory address
	reg[4:0]	boffset_in;	// Branch Offset
	reg[2:0]	funct_in;	// function code
	reg[2:0]	ALUfunct_in;	// ALU function Code
	reg[1:0]	op_in;		// Operation type
	reg[1:0] 	shamt_in;	// Shift Amount in
	reg		bne_in;		// Branch Flag 
	reg		jr_in;		// jump register?  - as of 9/8/16 I have forgot what this is supposed to do...
	reg[31:0]	PC_in;		// Program Counter from Pipeline
	reg[15:0]	memdata;	// for testing

	wire[31:0]	PC_out;
	wire [15:0]	mmuxout;	// data from either memory or ALU
	wire 		regwrite;

	reg[5:0]	error_count;
	reg[255:0]	message;

	Integration2 test(.clk(clk),
			.rst(rst),
			.reg1data_in(reg1data_in),	// Register 1 data	
			.reg2data_in(reg2data_in),	// Register 2 data	
			.jtarget_in(jtarget_in),	// Target to jump to 
			.memaddr_in(memaddr_in),	// Memory address
			.boffset_in(boffset_in),	// Branch Offset
			.funct_in(funct_in),	// function code
			.ALUfunct_in(ALUfunct_in),	// ALU function Code
			.op_in(op_in),	// Operation type
			.shamt_in(shamt_in),	// Shift Amount in
			.bne_in(bne_in),	// Branch Flag 
			.jr_in(jr_in),	// jump register?  - as of 9/8/16 I have forgot what this is supposed to do...
			.PC_in(PC_in),	// Program Counter from Pipeline
			.PC_out(PC_out),
			.mmuxout(mmuxout),
			.regwrite(regwrite),
			.memdata(memdata)	// for testing
		);

	initial begin
		$dumpfile("Integration_2_TB.vcd");
		$dumpvars(0, Integration2_TB);
		clk = 0; rst = 0; error_count = 0;
		#5 rst = 1;
		#5 rst = 0;

		op_in = 2'b00;	
		#10	check_mmuxout(



		$display("Finished Integration_1_TB Test Bench Error Count: %d", error_count);	
		#5 $finish;
	end
	always
	begin
		# 5 	clk = ~clk;
			check_regwrite_flag(op_in, regwrite, clk);
	end

	task check_mmuxout( 	input[15:0] mmuxout_exp,
				input[255:0] message
			);
		if (test.mmuxout != mmuxout_exp)
		begin
			error_count = error_count + 1;
			$display("MMuxout error: %s", message);
			$display("mmuxout expected: %b", mmuxout_exp);
			$display("mmuxout actual  : %b", test.mmuxout);
		end
	endtask

	task check_regwrite_flag(	input[1:0] op_in,
       					input regwrite_flag,
					input clk
				);
		if((op_in === 2'b00) && (regwrite_flag !== 1) && (clk == 1))
		begin
			$display("Regwrite_Flag not set");
			error_count = error_count + 1;
		end
	endtask

endmodule
