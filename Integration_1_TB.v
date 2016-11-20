/*
* 	Nathan Chinn, Bryan Lee
* 	Minion CPU - NanoQuarter
*
*	Module:  Integration 1
*	Inputs:  
*	Outputs: 
*
*/

// iverilog -o working.vpp Integration_1_TB.v && vvp working.vpp && gtkwave Integration_1_TB.vcd
`include "Integration_1.v"

module Integration1_TB();

	reg   		clk;
	reg	   	rst;
	reg[31:0] 	exInst;
	reg[31:0] 	PCNI;
	reg   		Mmuxout;
	reg   		regWrite;
	wire [1:0] 	shamt;
	wire		PC;	
	wire   		jmp;
	wire     	bne;
	wire   		memRead;
	wire    	memWrite;
	wire   		valid;
	wire[15:0]	reg1data;	
	wire[15:0]	reg2data;
	wire[2:0] 	ALU_func;
	wire[6:0] 	iVal;

	reg[4:0] error_count;
	reg[255:0] message;

	reg 		write_reg;
	reg 		write;
	reg[15:0]	mem_data;

	Integration1 test(.clk(clk),
			.rst(rst),
			.exInst(exInst),
			.PCNI(PCNI),
			.Mmuxout(Mmuxout),
			.regWrite(regWrite),
			.shamt(shamt),
			.PC(PC),
			.jmp(jmp),
			.bne(bne),
			.memRead(memRead),
			.memWrite(memWrite),
			.valid(valid),
		     	.reg1data(reg1data),
			.reg2data(reg2data),
		      	.ALU_func(ALU_func),
			.iVal(iVal),
			
			.mem_data(mem_data),
			.write_reg(write_reg),
			.write(write)	
		);

	initial begin
		$dumpfile("Integration_1_TB.vcd");
		$dumpvars(0, Integration1_TB);
		error_count = 0;	clk = 0;	rst = 0;
		write_reg = 0;

		$display("No Internal Write Flag"); error_count = error_count+1 ; write = 0;
		$display("Stall is broken"); error_count = error_count+1; 
		#5 rst = 1;
		#5 rst = 0;

		// LW r0, 0, 00
		// LW r1, 1, 00
		#10 	exInst = 32'b0100000000000000_0100000000100000;
			write = 1;	
		// Startup Latency of 2 clock cycles
		#10	write = 0; message = "Line __ LW r0";
			check_Prefetch(exInst[15:0], message);
			check_MainControl( 1, 0, 0, 0, 0, message);
		// ADD r0, r1, r2, 00
		// ADD r0, r1, r2, 00
		// Nada atm
		#10 	message = "Line __ LW r1";
			exInst = 32'b0000000001000000_0000000001000000;
			write = 1;	
			check_Prefetch(16'b0100000000000000, message);
			check_MainControl( 1, 0, 0, 0, 0, message);

			// should trigger stall
		#10	write = 0; message = "Line __ Add 0,1 put r2 - stall";
			write_reg = 1'b1;	mem_data = 1; // Register should be loaded
			check_Prefetch(exInst[15:0], message);
			check_MainControl( 0, 0, 0, 0, 1, message);

		// NAND r7, r2, r3, 01
		// XOR  r5, r6, r7, 11
		#10	write = 1; message = "Line __ Add 0,1 put r2";
			write_reg = 0;
			exInst = 32'b0010111011111000_0011101001101000;
			check_Prefetch(16'b0000000001000000, message);
			check_MainControl( 0, 0, 0, 0, 0, message);
			check_RegisterData(0, 0, message);

		#10	write = 0; message = "Line __ NAND 7,2 put r3 sh 01";
			check_Prefetch(exInst[15:0], message);
			check_RegisterData(0, 0, message);
			write_reg = 1; mem_data = 16'hFFFF;

		#10	write = 0; message = "Line __ XOR 5,6 put r7 sh 11";
			check_Prefetch(16'b0010111011111000, message);
			check_RegisterData(0, 0, message);
			
		//to simulate the stall detection from the instructions in line 87
		//which were overwrittng the next instruction tests in line 102
		//I copied the tests in 102 to be sure they re appeaered after stall was turned off
		//Edited by Bryan Lee
		// NAND r7, r2, r3, 01
		// XOR  r5, r6, r7, 11
		#10	write = 1; message = "Line __ Add 0,1 put r2";
			write_reg = 0;
			exInst = 32'b0010111011111000_0011101001101000;
			check_Prefetch(16'b0000000001000000, message);
			check_MainControl( 0, 0, 0, 0, 0, message);
			check_RegisterData(0, 0, message);

		#10	write = 0; message = "Line __ NAND 7,2 put r3 sh 01";
			check_Prefetch(exInst[15:0], message);
			check_RegisterData(0, 0, message);
			write_reg = 1; mem_data = 16'hFFFF;

		#10	write = 0; message = "Line __ XOR 5,6 put r7 sh 11";
			check_Prefetch(16'b0010111011111000, message);
			check_RegisterData(0, 0, message);

			




		$display("Finished Integration_1_TB Test Bench Error Count: %d", error_count);	
		#5 $finish;
	end
	always
		# 5 clk = ~clk;

	task check_Prefetch(	input[15:0] inst_wanted,
				input[255:0] message);
		if (inst_wanted !== test.inst)
		begin
			error_count = error_count + 1;
			$display("....................................................");
			$display("Prefetch Error", );
			$display("%s", message);
			$display("Instruction Wanted: %b", inst_wanted);	
			$display("Instruction Actual: %b\n", test.inst);	
			$display("Prefetch Instructi: %b", test.PrefetchBuffer.inst1);	
			$display("Prefetch Instructi: %b", test.PrefetchBuffer.inst2);	
			$display("Prefetch Memory   : %b", test.PrefetchBuffer.inst_mem);	
			$display("....................................................");
		end
	endtask

	task check_MainControl(	input 		memRd_flg_exp,
						memWrt_flg_exp,
						brnch_flg_exp,
						jmp_flg_exp,
						nop_flg_exp,
				input[255:0] message);
		if( 	{memRd_flg_exp, memWrt_flg_exp, brnch_flg_exp, jmp_flg_exp, nop_flg_exp} !==
			{test.memRd_flg, test.memWrt_flg, test.brnch_flg, test.jmp_flg, test.nop_flg}
		)
		begin
			error_count = error_count + 1;
			$display("....................................................");
			$display("Main Control Error", );
			$display("%s", message);
			$display("memRd_flg Wanted: %b", memRd_flg_exp);	
			$display("memRd_flg Actual: %b", test.memRd_flg);	
			$display("memWrt_flg Wanted: %b", memWrt_flg_exp);	
			$display("memWrt_flg Actual: %b", test.memWrt_flg);	
			$display("brnch_flg Wanted: %b", brnch_flg_exp);	
			$display("brnch_flg Actual: %b", test.brnch_flg);	
			$display("jmp_flg Wanted: %b", jmp_flg_exp);	
			$display("jmp_flg Actual: %b", test.jmp_flg);	
			$display("nop_flg Wanted: %b", nop_flg_exp);	
			$display("nop_flg Actual: %b", test.nop_flg);	
			$display("....................................................");
		end	
	endtask

	task check_RegisterData( input[15:0]	reg1data_exp,
						reg2data_exp,
				 input[255:0]	message);
		if( (reg1data_exp != test.reg1data) || (reg2data_exp != test.reg2data) )
		begin
			error_count = error_count + 1;
			$display("....................................................");
			$display("Register Error");
			$display("register1data expected: %b", reg1data_exp);
			$display("register1data actual  : %b", test.reg1data);
			$display("register2data expected: %b", reg2data_exp);
			$display("register2data actual  : %b", test.reg2data);
			$display("....................................................");
			
		end
	
	 endtask


endmodule
