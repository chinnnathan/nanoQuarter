/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Integration 1
*	Inputs:  
*	Outputs: 
*
*/

// iverilog -o working.vpp Processor_TB.v && vvp working.vpp && gtkwave Processor_TB.vcd
`include "Processor.v"

module Processor_TB
#(
  parameter REGWIDTH  = 7,
  parameter TESTWIDTH = 32
  );

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
	
	reg[255:0]	inst_message[17:0]; //17 test instructions
	reg[15:0]	ex_inst_count;
	reg		ex_inst_tstart;

	reg[15:0]	test_reg_data;
	reg[2:0]	test_reg_addr;

	integer i = 0;
	integer test_index = 0;

	Processor test(.clk(clk),
			.rst(rst)
		);

	initial begin
		$dumpfile("Processor_TB.vcd");
		$dumpvars(0, Processor_TB);
		error_count = 0;	clk = 0;	rst = 0;


		$display("No Internal Write Flag"); error_count = error_count+1 ; write = 0;
		$display("Stall is broken"); error_count = error_count+1; 
		#10 rst = 1;
		#10 rst = 0;	

		#10 	$display("Begin Processor Testing");
			write = 0;
			ex_inst_tstart = 0;
		for( test_index=0; test_index<=TESTWIDTH; test_index=test_index+1)
		begin
			@(posedge clk)
			$display("Instruction: %b", test.I1.inst);
		end

		@(posedge clk)
		$display("Instruction: %b", test.I1.inst);
		for( i=0; i<=7; i=i+1)
		begin
			$display("Register[%1d]: %b", i, test.I1.Registers.registers[i]);
		end




		#10 $display("Finished Processor_TB Test Bench Error Count: %d", error_count);	
		#10 $finish;
	end
	always
	begin
		# 5 clk = ~clk; 
	end



endmodule
