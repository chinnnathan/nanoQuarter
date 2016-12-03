/*
* 	Rebekah Tomsick - Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Main Control
*	Inputs:  stall flag, opcode from instruction, function from instruction
*	Outputs: jump flag, branch flag, no op flag, mem read & write flag
*
*/
// Run Command: 
// iverilog -o Main_Control_TB Main_Control_TB.v && vvp Main_Control_TB
// `timescale 1ns/100ps
`include "Main_Control.v"

module MainControl_TB();
	reg	   stall_flg;
	reg[1:0]   opcode;
	reg[2:0]   funct;
	wire 	jmp_flg, brnch_flg, nop_flg, memRd_flg, memWrt_flg;

	reg[255:0]	message;
	reg[4:0]	flg_test;	// test bench data
	reg[15:0]	error_count;

	MainControl test(	.opcode(opcode),	.funct(funct),
				.stall_flg(stall_flg),	.jmp_flg(jmp_flg),
				.nop_flg(nop_flg),	.brnch_flg(brnch_flg),
				.memRd_flg(memRd_flg),	.memWrt_flg(memWrt_flg)
			);	
	
	initial begin
		$dumpfile("Main_Control_TB.vcd");
		$dumpvars(0, MainControl_TB);
		error_count = 0;
		#5 	stall_flg = 0;	opcode = 2'b00;	funct = 3'b000;
			flg_test  = 5'b0_0_0_0_0;
			message = "Line37: NAND Operation";
			#5 check_output( flg_test, message);
		
		#5 	stall_flg = 0;	opcode = 2'b00;	funct = 3'b001;
			flg_test  = 5'b0_0_0_0_0;
			message = "Line 42: XOR Operation";
			#5 check_output( flg_test, message);
		
		#5 	stall_flg = 0;	opcode = 2'b00;	funct = 3'b010;
			flg_test  = 5'b0_0_0_0_0;
			message = "Line 47: SLL Operation";
			#5 check_output( flg_test, message);
		
		#5 	stall_flg = 0;	opcode = 2'b00;	funct = 3'b011;
			flg_test  = 5'b0_0_0_0_0;
			message = "Line 52: SRL Operation";
			#5 check_output( flg_test, message);
		
		#5 	stall_flg = 0;	opcode = 2'b00;	funct = 3'b100;
			flg_test  = 5'b0_0_0_0_0;
			message = "Line 57: SRA Operation";
			#5 check_output( flg_test, message);
		
		#5 	stall_flg = 0;	opcode = 2'b00;	funct = 3'b101;
			flg_test  = 5'b0_0_0_0_0;
			message = "Line 62: ADD Operation";
			#5 check_output( flg_test, message);
		
		#5 	stall_flg = 0;	opcode = 2'b00;	funct = 3'b110;
			flg_test  = 5'b0_0_0_0_0;
			message = "Line 67: SUB Operation";
			#5 check_output( flg_test, message);
		
		#5 	stall_flg = 0;	opcode = 2'b00;	funct = 3'b111;
			flg_test  = 5'b0_0_0_0_0;
			message = "Line 72: SW Operation";
			#5 check_output( flg_test, message);
		
		#5 	stall_flg = 0;	opcode = 2'b01;	funct = 3'b000;
			flg_test  = 5'b0_0_0_1_0;
			message = "Line 77: LW Operation";
			#5 check_output( flg_test, message);
		
		#5 	stall_flg = 0;	opcode = 2'b01;	funct = 3'b001;
			flg_test  = 5'b0_0_0_1_0;
			message = "Line 82: LB Operation";
			#5 check_output( flg_test, message);
		
		#5 	stall_flg = 0;	opcode = 2'b01;	funct = 3'b010;
			flg_test  = 5'b0_0_0_0_0;
			message = "Line 87: SB Operation";
			#5 check_output( flg_test, message);
		
		#5 	stall_flg = 1;	opcode = 2'b00;	funct = 3'b000;
			flg_test  = 5'b0_0_1_0_0;
			message = "Line 92: NAND Operation";
			#5 check_output( flg_test, message);

		$display("Finished Main_Control_TB Test Bench Error Count: %d", error_count);	
		#5 $finish;
	end

	task check_output( 	input[4:0] concat_flg,
				input[255:0] message);
		if(concat_flg !== {test.jmp_flg, test.brnch_flg, test.nop_flg, test.memRd_flg, test.memWrt_flg})
		begin
			error_count = error_count + 1;
			$display("Error: Flag data not equal");
			$display("Actual:   \t %b", {test.jmp_flg, test.brnch_flg, test.nop_flg, test.memRd_flg, test.memWrt_flg});
			$display("Testbench:\t %b", concat_flg);
			$display("Message: %s\n", message);
		end
	endtask

endmodule
