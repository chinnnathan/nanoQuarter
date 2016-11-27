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

module Processor_TB();

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
	reg[15:0]	ex_insts[16:0]; // 17 test instructions
	reg[15:0]	ex_inst_count;
	reg		ex_inst_tstart;

	Processor test(.clk(clk),
			.rst(rst),
			.write(write),
			.exInst(exInst)
		);

	initial begin
		$dumpfile("Processor_TB.vcd");
		$dumpvars(0, Processor_TB);
		error_count = 0;	clk = 0;	rst = 0;

		ex_insts[0]  = 16'b0100_1000_0010_0000; inst_message[0]  ="LUI r1, 000001, 00";
		ex_insts[1]  = 16'b0100_1000_0000_0000; inst_message[1]  ="LBI r0, 000000, 00 ";
		ex_insts[2]  = 16'b0000_0001_0100_0000; inst_message[2]  ="ADD r0, r1, r2, 00 ";
		ex_insts[3]  = 16'b0011_1010_0110_1000; inst_message[3]  ="NAND r7, r2, r3, 01 ";
		ex_insts[4]  = 16'b0010_1110_1111_1000; inst_message[4]  ="XOR  r5, r6, r7, 11 ";
		ex_insts[5]  = 16'b0000_1010_0110_0000; inst_message[5]  ="SLL  r1, r2, r3, 00 ";
		ex_insts[6]  = 16'b0000_0010_1001_0000; inst_message[6]  ="SRL  r0, r2, r4, 10 ";
		ex_insts[7]  = 16'b0000_1100_1010_0000; inst_message[7]  ="SRA  r1, r4, r5, 00 ";
		ex_insts[8]  = 16'b0001_0011_1100_0000; inst_message[8]  ="SUB  r2, r3, r6, 00 ";
		ex_insts[9]  = 16'b0000_0001_0100_1000; inst_message[9]  ="ADD  r0, r1, r2, 01 ";
		ex_insts[10] = 16'b0100_1000_0010_1000; inst_message[10] ="SUI  r1, 000001, 01 ";
		ex_insts[11] = 16'b0100_0010_1011_0000; inst_message[11] ="LUI  r0, 010101, 10  ";
		ex_insts[12] = 16'b0110_1111_0110_1000; inst_message[12] ="LBI  r5, 111011, 01 ";
		ex_insts[13] = 16'b0111_0101_0101_1000; inst_message[13] ="SBI  r6, 101010, 11 ";
		ex_insts[14] = 16'b1010_1000_0000_0000; inst_message[14] ="JR   r5, 00000000";
		ex_insts[15] = 16'b1000_0000_0010_1000; inst_message[15] ="JMP  r0, 00000101";
		ex_insts[16] = 16'b1100_1010_0111_0000; inst_message[16] ="BNE  r1, r2, 01110";

		$display("No Internal Write Flag"); error_count = error_count+1 ; write = 0;
		$display("Stall is broken"); error_count = error_count+1; 
		#10 rst = 1;
		#10 rst = 0;	

		ex_inst_count = 0; 	write = 1; 
		exInst = {ex_insts[ex_inst_count+1], ex_insts[ex_inst_count]};

		#10 $display("Some shiznit gunna happen");
		write = 0;	ex_inst_tstart = 1; ex_inst_count = test.I1.PC_out; 
		exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};

		#10  	ex_inst_count = ex_inst_count + 1; write = 1;
		#10 	ex_inst_count = test.I1.PC_out; write = 0;
			exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};
		#10 	ex_inst_count = ex_inst_count + 1; write = 1;
		#10 	ex_inst_count = test.I1.PC_out; write = 0;
			exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};
		#10  	ex_inst_count = ex_inst_count + 1; write = 1;
		#10 	ex_inst_count = test.I1.PC_out; write = 0;
			exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};
		#10  	ex_inst_count = ex_inst_count + 1; write = 1;
		#10 	ex_inst_count = test.I1.PC_out; write = 0;
			exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};
		#10  	ex_inst_count = ex_inst_count + 1; write = 1;
		#10 	ex_inst_count = test.I1.PC_out; write = 0;
			exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};
		#10  	ex_inst_count = ex_inst_count + 1; write = 1;
		#10 	ex_inst_count = test.I1.PC_out; write = 0;
			exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};
		#10  	ex_inst_count = ex_inst_count + 1; write = 1;
		#10 	ex_inst_count = test.I1.PC_out; write = 0;
			exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};
		#10  	ex_inst_count = ex_inst_count + 1; write = 1;
		#10 	ex_inst_count = test.I1.PC_out; write = 0;
			exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};
		#10  	ex_inst_count = ex_inst_count + 1; write = 1;
		#10 	ex_inst_count = test.I1.PC_out; write = 0;
			exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};
		#10  	ex_inst_count = ex_inst_count + 1; write = 1;
		#10 	ex_inst_count = test.I1.PC_out; write = 0;
			exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};
		#10  	ex_inst_count = ex_inst_count + 1; write = 1;
		#10 	ex_inst_count = test.I1.PC_out; write = 0;
			exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};
		#10  	ex_inst_count = ex_inst_count + 1; write = 1;
		#10 	ex_inst_count = test.I1.PC_out; write = 0;
			exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};
		#10  	ex_inst_count = ex_inst_count + 1; write = 1;
		#10 	ex_inst_count = test.I1.PC_out; write = 0;
			exInst = {ex_insts[ex_inst_count+3], ex_insts[ex_inst_count+2]};












		//#10 $display("Finished Processor_TB Test Bench Error Count: %d", error_count);	
		//#10 $finish;
		$finish;
	end
	always
	begin
		# 5 clk = ~clk;
		check_instruction_test(	clk,		ex_insts[ex_inst_count], 
					ex_inst_tstart,	inst_message[ex_inst_count]);
	end

	task check_instruction_test(	input			clk,
					input[15:0]		ex_inst,
					input			start,
					input[255:0]		message

				);
		if( 	(start === 1'b1 && clk === 1'b1)
			&& (ex_inst != test.I1.PrefetchBuffer.inst))
		begin
			$display("Instruction Error: %s", message);
			$display("Actual inst: %b", test.I1.PrefetchBuffer.inst);
			$display("Expect inst: %b", ex_inst);
			$display("PC address: %d", test.I1.PC_out);
		end
	endtask

endmodule
