/*
* 	Derek Cook
* 	Edited to work by Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Branch Adder TB
*	Inputs:  boff, PC_n, bne
*	Outputs: bsel
*
*/
`include "branch_add.v"
module Branch_Add_TB();

	reg[4:0] 	boff;
	reg[31:0]   PC_n;
	reg         bne;
	
	wire[31:0] 	bsel; 

	

	BranchAdd test(	.boff(boff), .PC_n(PC_n), .bne(bne), .bsel(bsel));


	initial begin
		$dumpfile("Branch_Add_TB.vcd");
		$dumpvars(0, Branch_Add_TB);
		
		#10 PC_n = 32'b00000000000000000000000000000000;	bne = 0; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000001;	bne = 0; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000010;	bne = 0; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000011;	bne = 0; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000100;	bne = 0; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000101;	bne = 0; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000110;	bne = 0; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000111;	bne = 0; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000001000;	bne = 0; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000001001;	bne = 0; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000000;	bne = 1; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000001;	bne = 1; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000010;	bne = 1; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000011;	bne = 1; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000100;	bne = 1; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000101;	bne = 1; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000110;	bne = 1; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000000111;	bne = 1; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000001000;	bne = 1; boff = 5'b00000;
		#10 PC_n = 32'b00000000000000000000000000001001;	bne = 1; boff = 5'b00000;
		#5 $display("Finished Branch Adder Test Bench. ");
		$finish;

	end
endmodule
