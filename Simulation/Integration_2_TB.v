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
	reg[7:0]	idata_in;	// Immediate Data from instruction
	reg[7:0]	jtarget_in;	// Target to jump to 
	reg[5:0]	memaddr_in;	// Memory address
	reg[4:0]	boffset_in;	// Branch Offset
	reg[2:0]	funct_in;	// function code
	reg[1:0]	op_in;		// Operation type
	reg[1:0] 	shamt_in;	// Shift Amount in
	reg		bne_in;		// Branch Flag 
	reg		jr_in;		// jump register?  - as of 9/8/16 I have forgot what this is supposed to do...
	reg		jmp;
	reg		memread;
	reg[31:0]	PC_in;		// Program Counter from Pipeline
	reg[15:0]	memdata;	// for testing

	wire[31:0]	PC_out;
	wire [15:0]	mmuxout;	// data from either memory or ALU
	wire 		regwrite;

	reg[5:0]	error_count;
	reg[15:0]	ALUout_test;
	reg[31:0]	PC_n_test;
	reg[255:0]	message;

	Integration2 test(.clk(clk),
			.rst(rst),
			.reg1data_in(reg1data_in),	// Register 1 data	
			.reg2data_in(reg2data_in),	// Register 2 data	
			.idata_in(idata_in),		// Target to jump to 
			.jtarget_in(jtarget_in),	// Target to jump to 
			.memaddr_in(memaddr_in),	// Memory address
			.boffset_in(boffset_in),	// Branch Offset
			.funct_in(funct_in),		// function code
			.op_in(op_in),			// Operation type
			.shamt_in(shamt_in),		// Shift Amount in
			.bne_in(bne_in),		// Branch Flag 
			.jr_in(jr_in),			// jump register?  - as of 9/8/16 I have forgot what this is supposed to do...
			.jmp(jmp),
			.memread(memread),
			.memwrite(memwrite),
			.PC_in(PC_in),			// Program Counter from Pipeline
			.PC_out(PC_out),
			.mmuxout(mmuxout),
			.regwrite(regwrite),
			.memdata(memdata)		// for testing
		);

	initial begin
		$dumpfile("Integration_2_TB.vcd");
		$dumpvars(0, Integration2_TB);
		clk = 0; rst = 0; error_count = 0; 

		PC_in	= 0;
		PC_n_test = 2;
		bne_in	= 0;
		jmp	= 0;
		boffset_in = 3'b000;
		memaddr_in = 5'b00000;
		idata_in   = 8'b0000_0000;
		memdata = 16'b1010_1111_1010_0000;
		reg1data_in = 16'b0000_1000_0000_1111;
		reg2data_in = 16'b1000_0000_1111_1001;

		#5 rst = 1;
		#5 rst = 0;

		//NAND r7, r2, r3, 01
		#10	message = "NAND r7,r2,r3,01";
			op_in 		= 2'b00;
			funct_in 	= 3'b000;
			memread 	= 1'b0;	
			shamt_in 	= 2'b01;	
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b0000_1000_0000_1111;
			reg2data_in 	= 16'b1000_0000_1111_1001;
			ALUout_test 	= 16'b1111_1111_1111_0110 << shamt_in;

		#10	ALU_out_check(ALUout_test, message);
			check_mmuxout(ALUout_test, message);
		//XOR r5,r6,r7,11
			message = "XOR r5,r6,r7,11";
			op_in 		= 2'b00;
			funct_in 	= 3'b001;
			memread 	= 1'b0;	
			shamt_in 	= 2'b11;	
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b0000_1000_0000_1111;
			reg2data_in 	= 16'b1000_0000_1111_1001;
			ALUout_test 	= 16'b1000_1000_1111_0110 << shamt_in;

		#10	ALU_out_check(ALUout_test, message);
			check_mmuxout(ALUout_test, message);
		//SLL r1,r2,r3,00
			message = "SLL r1,r2,r3,00";
			op_in 		= 2'b00;
			funct_in 	= 3'b010;
			memread 	= 1'b0;	
			shamt_in 	= 2'b00;	
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b0000_1000_0000_1111;
			reg2data_in 	= 16'b0000_0000_0000_0001;
			ALUout_test 	= 16'b0001_0000_0001_1110 << shamt_in;

		#10	ALU_out_check(ALUout_test, message);
			check_mmuxout(ALUout_test, message);
		//SRL r1,r2,r3,00
			message = "SRL r1,r2,r3,00";
			op_in 		= 2'b00;
			funct_in 	= 3'b011;
			memread 	= 1'b0;	
			shamt_in 	= 2'b00;	
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b0000_1000_0000_1111;
			reg2data_in 	= 16'b0000_0000_0000_0001;
			ALUout_test 	= 16'b0000_0100_0000_0111 << shamt_in;

		#10	ALU_out_check(ALUout_test, message);
			check_mmuxout(ALUout_test, message);
		//SRA r1,r2,r3,00
			message = "SRL r1,r2,r3,00";
			op_in 		= 2'b00;
			funct_in 	= 3'b100;
			memread 	= 1'b0;	
			shamt_in 	= 2'b00;	
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b0000_1000_0000_1111;
			reg2data_in 	= 16'b0000_0000_0000_0001;
			ALUout_test 	= 16'b0000_0100_0000_0111 << shamt_in;

		#10	ALU_out_check(ALUout_test, message);
			check_mmuxout(ALUout_test, message);
		//ADD r1,r2,r3,01
			message = "ADD r1, r2, r3, 01";
			op_in 		= 2'b00;
			funct_in 	= 3'b101;
			memread 	= 1'b0;	
			shamt_in 	= 2'b01;	
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b0000_1000_0000_1111;
			reg2data_in 	= 16'b0000_0000_0000_0001;
			ALUout_test 	= 16'b0000_1000_0001_0000 << shamt_in;

		#10	ALU_out_check(ALUout_test, message);
			check_mmuxout(ALUout_test, message);
		//SUB r1,r2,r3,11
			message = "ADD r1, r2, r3, 01";
			op_in 		= 2'b00;
			funct_in 	= 3'b110;
			memread 	= 1'b0;	
			shamt_in 	= 2'b11;	
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b0000_1000_0000_1111;
			reg2data_in 	= 16'b0000_0000_0000_0001;
			ALUout_test 	= 16'b0000_1000_0000_1110 << shamt_in;

		#10	ALU_out_check(ALUout_test, message);
			check_mmuxout(ALUout_test, message);
		$display("Basic R-Type Testing Completed, Errors: %d", error_count);

		//LUI r1, 1010_1010
			message = "LUI r0, 101010, 10";
			op_in 		= 2'b01;
			funct_in 	= 3'b000;
			memread 	= 1'b0;	
			shamt_in 	= 2'b11;	
			idata_in	= 8'b1010_1010;
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b1111_1111_1111_1111;
			reg2data_in 	= 16'b1111_1111_1111_1111;
			ALUout_test 	= 16'b1010_1010_0000_0000;

		//LBI r1, 1000_1000
		#10	ALU_out_check(ALUout_test, message);
			check_mmuxout(ALUout_test, message);
			message = "LBI r0, 101010, 10";
			op_in 		= 2'b01;
			funct_in 	= 3'b001;
			memread 	= 1'b0;	
			shamt_in 	= 2'b11;	
			idata_in	= 8'b1000_1000;
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b1111_1111_1111_1111;
			reg2data_in 	= 16'b1111_1111_1111_1111;
			ALUout_test 	= 16'b0000_0000_1000_1000;

		//SUI r1, 1000_0001
		#10	ALU_out_check(ALUout_test, message);
			check_mmuxout(ALUout_test, message);
			message = "SUI r0, 10000, 01";
			op_in 		= 2'b01;
			funct_in 	= 3'b010;
			memread 	= 1'b0;	
			shamt_in 	= 2'b11;	
			idata_in	= 8'b1000_0001;
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b1111_1111_1111_1111;
			reg2data_in 	= 16'b1111_1111_1111_1111;
			ALUout_test 	= 16'b1000_0001_0000_0000;

		//SBI r1, 1000_0001
		#10	ALU_out_check(ALUout_test, message);
			check_mmuxout(ALUout_test, message);
			message = "SBI r0, 10000, 01";
			op_in 		= 2'b01;
			funct_in 	= 3'b011;
			memread 	= 1'b0;	
			shamt_in 	= 2'b11;	
			idata_in	= 8'b1000_0001;
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b1111_1111_1111_1111;
			reg2data_in 	= 16'b1111_1111_1111_1111;
			ALUout_test 	= 16'b0000_0000_1000_0001;

		#10	ALU_out_check(ALUout_test, message);
			check_mmuxout(ALUout_test, message);
		$display("Instantaneous I-Type Testing Completed, Errors: %d", error_count);

		//JMP r5, 1100000
			message = "JMP r5, 11000000";
			op_in 		= 2'b10;
			funct_in 	= 3'b000;
			memread 	= 1'b0;	
			jmp		= 1'b1;
			shamt_in 	= 2'b11;	
			idata_in	= 8'b1000_0001;
			jtarget_in	= 8'b1100_0000;
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b0111_1111_1111_1111;
			PC_n_test	= PC_in + jtarget_in;

		//JR r5, 1100000
		#10
			message = "JR r5, 11000000";
			op_in 		= 2'b10;
			funct_in 	= 3'b001;
			memread 	= 1'b0;	
			jmp		= 1'b1;
			shamt_in 	= 2'b11;	
			idata_in	= 8'b1000_0001;
			jtarget_in	= 8'b1100_0000;
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b0111_1111_1111_1111;
			PC_n_test	= PC_in + reg1data_in;

		//BNE r1, r2, 01110
		#10
			message = "BNE r1,r2,01110";
			op_in 		= 2'b11;
			funct_in 	= 3'b000;
			memread 	= 1'b0;	
			jmp		= 1'b0;
			bne_in		= 1'b1;
			shamt_in 	= 2'b11;	
			idata_in	= 8'b1000_0001;
			jtarget_in	= 8'b1100_0000;
			memdata 	= 16'b1010_1111_1010_0000;
			reg1data_in 	= 16'b0111_1111_1111_1111;
			reg2data_in 	= 16'b0111_0111_1111_1111;
			PC_n_test	= PC_in + boffset_in;
		#10	
		$display("J-Type Testing Completed, Errors: %d", error_count);
			

		$display("Finished Integration_2_TB Test Bench Error Count: %d", error_count);	
		#5 $finish;
	end
	always
	begin
		# 5 	clk = ~clk;
			check_regwrite_flag(op_in, funct_in, regwrite, clk);
			check_PC_n(PC_n_test, clk);
	end

	task check_regwrite_flag(	input[1:0] op_in,
					input[2:0] funct_in,
       					input regwrite_flag,
					input clk
				);
		// regwrite high for all R-Type and all Load I-Type
		if( 
			((op_in === 2'b00) && (regwrite_flag !== 1)
			|| ((op_in === 2'b01) && (funct_in <=3'b001)  && (regwrite_flag !== 1)))
			&& (clk == 1)
		)
		begin
			$display("Regwrite_Flag not set");
			error_count = error_count + 1;
		end
	endtask

	task check_PC_n(	input[31:0] PC_n_exp,
				input clk);
		if( (PC_n_exp !== test.PC_out) && clk == 1)
		begin
			$display("PC Count Error");
			$display("PC Actual: %b", test.PC_out);
			$display("PC Expect: %b", PC_n_exp);
			error_count = error_count + 1;
		end
	endtask

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


	task ALU_out_check(	input[15:0] ALU_exp,
				input[255:0] message
			);
		if(test.ALUout !== ALU_exp)
		begin
			error_count = error_count + 1;
			$display("ALU_out error: %s", message);
			$display("ALU_out actual: %b", test.ALUout);
			$display("ALU_out wanted: %b", ALU_exp);

			$display("ALU Op in: %b", test.A.op);
			$display("ALU funt in: %b", test.A.funct);
			$display("ALU shamt in: %b", test.A.shamt);
			$display("ALU memdata in: %b", test.A.memdata);
			$display("ALU reg1 in: %b", test.A.reg1data);
			$display("ALU reg2 in: %b", test.A.reg2data);
			$display("ALU ALUout in: %b", test.A.ALUout);
		end

	endtask

endmodule
