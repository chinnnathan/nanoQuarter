/*testbench by bryanlee
	Edited to work by Nathan Chinn
*/

`include "ALU_Control.v"
module ALUControl_TB();
reg [15:0] inst;
wire[2:0] func;
wire[1:0] shamt;
wire jr;

ALUControl ALUControl_testbench(.func(func),
				.shamt(shamt),
				.jr(jr),
				.inst(inst));

initial begin
	$dumpfile("ALU_Control_TB.vcd");
	$dumpvars(0, ALUControl_TB);
	//initialize the instructions to be tested, one of each type

	//r type - opcode 00, rSource r0 and r1, rDest r2, shift 0, function add 101
	//in hex it is h0145, shift 0, jump 0, funct 101 (5)
	#10 inst = 16'b00_000_001_010_00_101; 

	//i type - opcode 01, rSource r3, mem add 101010, shift 2 (2'b10), func 010
 	//in hex it is h5D52, shift 2, jump 0, funct 010 (2)
	#10 inst = 16'b01_011_101010_10_010;

	//j type - opcode 10, rSource r4, target add 11111111, function 001
	//in hex it is hA7F9, jump 1, shift 0, func 001 (1)
	#10 inst = 16'b10_100_11111111_001; 

	//b type - opcode 11, rSource r5 and r6, offset = 000111, func 000
	//in hex it is hEE18, jump 0, shift 0, func 000 (0)
	#10 inst = 16'b11_101_110_00011_000; 
	


end
endmodule
