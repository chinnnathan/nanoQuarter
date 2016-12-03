/*
* 	Nathan Chinn - Bryan Lee
* 	Minion CPU - NanoQuarter
*
*	Module:  Stall Unit
*	Inputs:  opcode, register source 1, register source 2, register
*		 destination, program counter
*	Outputs: stall flag, Program counter
*
*/
`include "Stall_Unit.v"
module StallUnit_TB();
	reg		clk;	// System Clock
	reg   		rst; 	// System Reset
	reg[1:0]	opcode;	// operation code
	reg[2:0]	rs1;	// register source 1
	reg[2:0] 	rs2;	// register source 2
	reg[2:0]   	rd;	// register destination
	reg[31:0]	pc_old;	// program counter in
	wire		stall_flg; // Flag set high when stall required

	reg		stall_flg_test;
	reg[15:0] 	error_count;
	reg[255:0]	message;


	StallUnit test (	.clk(clk),	.rst(rst),	.opcode(opcode),
				.rs1(rs1),	.rs2(rs2),	.rd(rd),
				.pc_old(pc_old), 		.stall_flg(stall_flg));

	initial begin
		$dumpfile("StallUnit_TB.vcd");
		$dumpvars(0, StallUnit_TB);

		clk = 0;	rst = 0;
		rs1 = 3'b001;	rs2 = 3'b010;	rd = 3'b011;	opcode=2'b00;
		error_count = 0;

		//#5 	rs1 = 3'b001;	rs2 = 3'b010;	rd = 3'b011;	opcode=2'b00;

		#5 	rs1 = 3'b001;	rs2 = 3'b010;	rd = 3'b011;	opcode=2'b00;
			stall_flg_test = 0;	
			message = "Line 45: No Stall";
			#5 check_stall_flg( stall_flg_test, message);


		#5 	rs1 = 3'b011;	rs2 = 3'b010;	rd = 3'b010;	opcode=2'b00;
			stall_flg_test = 1;	
			message = "Line 51: Stall Detected";
			#5 check_stall_flg( stall_flg_test, message);

		#5 	rs1 = 3'b011;	rs2 = 3'b010;	rd = 3'b010;	opcode=2'b00;
			stall_flg_test = 0;	
			message = "Line 56: Stall Fixed";
			#5 check_stall_flg( stall_flg_test, message);

		#5 	rs1 = 3'b011;	rs2 = 3'b000;	rd = 3'b010;	opcode=2'b00;
			stall_flg_test = 0;	
			message = "Line 61: No Stall";
			#5 check_stall_flg( stall_flg_test, message);

		#5 	rs1 = 3'b101;	rs2 = 3'b100;	rd = 3'b110;	opcode=2'b00;
			stall_flg_test = 0;	
			message = "Line 66: No Stall";
			#5 check_stall_flg( stall_flg_test, message);


		#15 $display("Finished Stall_Unit Test Bench. Error Count: %d", error_count);
		    $finish;	
	end

	always 
		#5 clk = ~clk;

	task check_stall_flg( 	input	stall_flg,
				input[255:0] message);
		if(stall_flg !== test.stall_flg)
		begin
			error_count = error_count + 1;
			$display("Error: Stall_flg data not equal");
			$display("Actual:   \t %b", test.stall_flg);
			$display("Testbench:\t %b", stall_flg);
			$display("Message: %s\n", message);
		end
	endtask
endmodule
			
