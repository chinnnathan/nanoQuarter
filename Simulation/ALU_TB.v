/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  ALU_TB
*	Inputs:  reg1data, reg2data, ALU function, Shift Amount,
*		 op code
*	Outputs: Bsel PC after branch selection
*	Note: 	 This will serve as a good example for a test bench
*	
*/

// `timescale 1ns/100ps
`include "ALU.v"

module ALU_TB();
	reg[1:0]	op;    		// Operation Code for decode
	reg[15:0]	memdata;	// Data from Memory
	reg[2:0]	funct;		// Function Code
	reg[1:0]	shamt;		// Shift Amount
	reg[15:0]	reg1data,	// Registerr Data
			reg2data;	// Registerr Data
	wire[15:0]	ALUout;		// Data from ALU

	reg[255:0]	message;
	reg[15:0]	ALUout_test;	// test bench data
	reg[15:0]	error_count;

	ALU test(	.op(op), 		.memdata(memdata), 	.funct(funct), 
		 	.shamt(shamt),		.ALUout(ALUout),	
		        .reg1data(reg1data),	.reg2data(reg2data)
		);	
	
	initial begin
		$dumpfile("ALU_TB.vcd");
		$dumpvars(0, ALU_TB);
		error_count = 0;

		#5 	op 	= 2'b00;	memdata = 16'b0000_0000_1010_1111;
			funct 	= 3'b000;	shamt	=  2'b00;

			reg1data = 16'b0000_1010_1111_0000;
			reg2data = 16'b0100_1110_1111_0000;

			ALUout_test = 16'b1111_0101_0000_1111;

			message = "NAND Operation";
			#5 check_output( ALUout_test, message);

		#5 	op 	= 2'b00;	memdata = 16'b0000_0000_1010_1111;
			funct 	= 3'b001;	shamt	=  2'b00;

			reg1data = 16'b0000_1010_1111_0000;
			reg2data = 16'b0100_1110_1111_0000;

			ALUout_test = 16'b0100_0100_0000_0000;

			message = "XOR Operation";
			#5 check_output( ALUout_test, message);
			
		#5 	op 	= 2'b00;	memdata = 16'b0000_0000_1010_1111;
			funct 	= 3'b010;	shamt	=  2'b00;

			reg1data = 16'b0100_1110_1111_0000;
			reg2data = 16'b0000_0000_0000_0010;

			ALUout_test = 16'b0011_1011_1100_0000;

			message = "Shift Left Logical Operation";
			#5 check_output( ALUout_test, message);

		#5 	op 	= 2'b00;	memdata = 16'b0000_0000_1010_1111;
			funct 	= 3'b011;	shamt	=  2'b00;

			reg1data = 16'b0100_1110_1111_0000;
			reg2data = 16'b0000_0000_0000_0010;

			ALUout_test = 16'b0001_0011_1011_1100;

			message = "Shift Right Logical Operation";
			#5 check_output( ALUout_test, message);

		#5 	op 	= 2'b00;	memdata = 16'b0000_0000_1010_1111;
			funct 	= 3'b100;	shamt	=  2'b00;

			reg1data = 16'b0100_1110_1111_0000;
			reg2data = 16'b0000_0000_0000_0010;

			ALUout_test = 16'b0001_0011_1011_1100;

			message = "Shift Right Arithmetic Operation";
			#5 check_output( ALUout_test, message);

		#5 	op 	= 2'b00;	memdata = 16'b0000_0000_1010_1111;
			funct 	= 3'b101;	shamt	=  2'b00;

			reg1data = 16'b0100_1110_1111_0100;
			reg2data = 16'b0000_0000_0000_0010;

			ALUout_test = 16'b0100_1110_1111_0110;

			message = "Add Operation";
			#5 check_output( ALUout_test, message);

		#5 	op 	= 2'b00;	memdata = 16'b0000_0000_1010_1111;
			funct 	= 3'b110;	shamt	=  2'b00;

			reg1data = 16'b0100_1110_1111_0110;
			reg2data = 16'b0000_0000_0000_0010;

			ALUout_test = 16'b0100_1110_1111_0100;

			message = "Subtract Operation";
			#5 check_output( ALUout_test, message);

		$display("Finished ALU_TB Test Bench Error Count: %d", error_count);	
		#5 $finish;
	end

	task check_output( 	input[15:0] out,
				input[255:0] message);
		if(out !== test.ALUout)
		begin
			error_count = error_count + 1;
			$display("Error: ALUout actual data not equal");
			$display("Actual:   \t %b", test.ALUout);
			$display("Testbench:\t %b", out);
			$display("Message: %s\n", message);
		end
	endtask

endmodule
