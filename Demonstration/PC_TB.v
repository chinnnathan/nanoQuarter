/*
* 	Nathan Chinn - Daren Dickenson
* 	Minion CPU - NanoQuarter
*
*	Module:  Program Counter
*	Inputs:  clock, reset, new PC
*	Outputs: Program Counter
*
*/
`include "PC.v"
module PC_TB();

	reg 		clk; // System Clock
	reg	   	rst; // System Reset
	reg[31:0] 	new_PC; // PC in 
	wire[31:0] 	PC_out; //PC out

	reg[225:0]	message;
	reg[31:0]	PC_check;
	reg[7:0]	error_count;

	PC test(	.clk(clk),		.rst(rst),
			.new_PC(new_PC),	.PC_out(PC_out)
		);

	initial begin
		$dumpfile("PC_TB.vcd");
		$dumpvars(0, PC_TB);
		clk = 0;	error_count = 0;	rst = 0;
		new_PC = 32'h0;

		#5 rst = 1;
		#5 	rst = 0;	PC_check = 0;	message = "Line 33: Reset";
			new_PC = new_PC + 2; 
			check_output( PC_check, message);

		#10	PC_check = PC_check + 2;	message = "Line 37: PC increment";
			new_PC = new_PC + 4; 
			check_output( PC_check, message);

		#10	PC_check = PC_check + 4;	message = "Line 41: PC increment";
			check_output( PC_check, message);


		#5 $display("Finished PC Test Bench. Error Count: %d", error_count);
		$finish;

	end
	always
		#5 clk = ~clk;

	task check_output( 	input[31:0] test_PC,
				input[255:0] message);
		if(test_PC !== test.PC_out)
		begin
			error_count = error_count + 1;
			$display("Error: PC not equal");
			$display("Actual:   \t %h", test.PC_out);
			$display("Testbench:\t %h", test_PC);
			$display("Message: %s\n", message);
		end
	endtask
endmodule


