/*
* 	Nathan Chinn - Bryan Lee - Derek Cook
* 	Minion CPU - NanoQuarter
*
*	Module:  Pre-Fetch Buffer testbench
*	Inputs:  instruction 1, instruction 2, write protect bar
*	Outputs: instruction
*	
*	Note: This works to solve a 1 clock cycle latency in APB
*/
`include "PreFetch_Buffer.v"

module PrefetchBuffer_TB();

	reg 		clk, rst;
	reg[15:0] 	inst1,
			inst2;
	reg 		write;
	wire [15:0] 	inst;


	reg[15:0]	inst_test;
	reg[7:0]	error_count;
	reg[255:0]	message;

	PrefetchBuffer test(	.inst(inst), 	.write(write), 
			.inst1(inst1), 	.inst2(inst2), 
			.clk(clk), 	.rst(rst)
			);

	initial begin
		$dumpfile("PrefetchBuffer_TB.vcd");
		$dumpvars(0, PrefetchBuffer_TB);
		rst = 1;
		clk = 0;	error_count = 0;	write = 1'b0;

		#5 	inst1 = 16'h0000; 	inst2 = 16'h0001; write = 1'b1;
			inst_test = 16'h0000;	message = "Line 35: 0th (Start Data)";
			#5 check_inst_out(inst_test, message);

		#5 	inst1 = 16'hXXXX; 	inst2 = 16'hXXXX; write = 1'b0;
			inst_test = 16'h0001;	message = "Line 42: 1st Inst out";
			#5 check_inst_out(inst_test, message);

		#5 	inst1 = 16'h0002; 	inst2 = 16'h0003; write = 1'b1;
			inst_test = 16'h0002;	message = "Line 48: 2nd Inst out";
			#5 check_inst_out(inst_test, message);

		#5 	inst1 = 16'hXXXX; 	inst2 = 16'hXXXX; write = 1'b0;
			inst_test = 16'h0003;	message = "Line 50: 3rd Inst out";
			#5 check_inst_out(inst_test, message);

		#5 	inst1 = 16'h0004; 	inst2 = 16'h0005; write = 1'b1;
			inst_test = 16'h0004;	message = "Line 54: 4th Inst out";
			#5 check_inst_out(inst_test, message);

		#5 	inst1 = 16'h0008; 	inst2 = 16'h0009; write = 1'b0;
			inst_test = 16'h0005;	message = "Line 58: 5th Inst out (last)";
			#5 check_inst_out(inst_test, message);


		#10 $display("Error Count: %d", error_count);
		$finish;
	end

	always
		#5 clk = ~clk;

	task check_inst_out( 	input[15:0]	inst_test,	
				input[255:0] 	message);
		if(inst_test !== test.inst)
		if(1)
		begin
			error_count = error_count + 1;
			$display("Error: instruction data not equal");
			$display("Actual:   \t %h", test.inst);
			$display("Testbench:\t %h", inst_test);
			$display("Buffer Instruction memory: %h", test.inst_mem);
			$display("Message: %s\n", message);
		end
	endtask

endmodule
