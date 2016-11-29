/*
* 	Bryan Lee
* 	Minion CPU - NanoQuarter
*
*	Module:  next Program Counter TB
*	Inputs:  clock, reset
*	Outputs: Program Counter, Program Counter Next
*
*/
module next_PC_TB();
	reg clk, rst;
	wire [31:0] next_PC;
	wire [31:0] PC_out;

	next_PC testNextPC(		.PC(PC_out),
				.next_PC(next_PC)
				);
	PC testPC(				.clk(clk),
					.rst(rst),
					.new_PC(next_PC),
					.PC_out(PC_out)
			);
					
	initial begin
		clk = 0; rst = 0;
		#5 rst = 1;
		#5 rst = 0;
		#10; //PC = 4
		#10; //PC = 8
		#10; //PC = 12 or C
		$stop;
	end

always 
	#5 clk = ~clk;

endmodule
