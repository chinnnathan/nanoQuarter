/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  PC Next Instruction Mux Test Bench
*	Inputs:  jump addr, jump, Branch Sel
*	Outputs: PC next instruction
*	
*/
`include "PC_NI_MUX.v"

module PCNIMUX_TB();

	reg[15:0]	jaddr;  // Jump address
	reg[31:0]	bsel;	// Program Counter from Branch 
	reg		jmp;	// Jump Flag
	wire[31:0]	PCNI;	// Next Instruction Program Counter	

	reg[7:0]	error_count;
	reg[31:0]	PCNI_test;
	reg[255:0]	message;

	PCNIMUX test(	.jaddr(jaddr),	.bsel(bsel),
			.jmp(jmp),	.PCNI(PCNI)
			);
	initial 
	begin
		$dumpfile("PCNIMUX_TB.vcd");
		$dumpvars(0, PCNIMUX_TB);

		error_count = 0;

		#5	jaddr = 16'h0000;	bsel 	  = 32'h00000002;
			jmp   = 0;		PCNI_test = 32'h00000002;
			message = "Line 35: no Jump";
			#5 check_PC_NI( PCNI_test, message);

		#5	jaddr = 16'h0001;	bsel 	  = 32'h00000002;
			jmp   = 1;		PCNI_test = 32'h00000003;
			message = "Line 40: Jump";
			#5 check_PC_NI( PCNI_test, message);

		#5	jaddr = 16'hFFFF;	bsel 	  = 32'h000000F1;
			jmp   = 1;		PCNI_test = 32'h000000F0;
			message = "Line 40: Jump Negative";
			#5 check_PC_NI( PCNI_test, message);
	
		
		#5 $display("PC_NI_MUX_TB finished, error count: %d", error_count);	
		$finish;

	end

	task check_PC_NI( 	input[31:0]	PC_NI_test,
				input[255:0]	message);
		if(PC_NI_test !== test.PCNI)
		begin
			error_count = error_count + 1;
			$display("Error: PCNI data not equal");
			$display("Actual:   \t %b", test.PCNI);
			$display("Testbench:\t %b", PC_NI_test);
			$display("Message: %s\n", message);
		end
	endtask
endmodule
