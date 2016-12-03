/*
Testbench by Bryan Lee
Edited to Work by Nathan Chinn
*/

`include "Jump_Calc.v"
module JumpCalc_TB();
reg[15:0] reg1data;
reg[7:0] jtarget;
reg[2:0] funct;
wire[15:0] jaddr;

JumpCalc test(.jaddr(jaddr), .funct(funct), .jtarget(jtarget), .reg1data(reg1data));

initial begin
	$dumpfile("Jump_Calc_TB.vcd");
	$dumpvars(0, JumpCalc_TB);
	jtarget = 8'hAA; // address in memory, AA
	reg1data = 16'b0000011111111000; //random register filled with an address

	//jump function, where the jaddress output becomes the target memory location
	#10 funct = 3'b000; //jump function

	//Jump Reg function, where the jaddress output becomes the register target bits 3-10
	#10 funct = 3'b001; //Jump Register data address
	    
end
endmodule
