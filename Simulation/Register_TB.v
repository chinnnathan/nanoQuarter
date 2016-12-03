/*
* 	Derek Cook
* 	Edited to Work by Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Register TB
*	Inputs:  clock, reset, rest1, rst2, rd , data_in, wp_
*	Outputs: reg1data, reg2data
*
*/
`include "registers.v"
module Register_TB();

	reg 		clk, rst, write_reg;
	reg[2:0]    rs1, rs2, rd;
	reg[15:0]   data_in;
	
	wire[15:0] 	reg1data, reg2data; 

	reg[4:0] error_count;

	

	Registers test(	.clk(clk), .rst(rst), .rs1(rs1), .rs2(rs2), .rd(rd), 
		       .data_in(data_in), .write_reg(write_reg), .reg1data(reg1data), .reg2data(reg2data));


	initial begin
		$dumpfile("Register_TB.vcd");
		$dumpvars(0, Register_TB);
		clk = 0;	error_count = 0;	rst = 0;

		#10 rst = 1;

		#10 rst = 0;	rs1 = 0; rs2 = 1; rd = 2; data_in = 16'hFFFF; 

		#10 rst = 0;	rs1 = 1; rs2 = 2; write_reg = 1;
		
		#10 rst = 0;	rs1 = 1; rs2 = 2; write_reg = 0;

		#10 rs1 = 0; rs2 = 2; 
		Check_Internal_Registers( 2, data_in, "Line 46");

		#10 rs1 = 0; rs2 = 2; 
		Check_Internal_Registers( 2, data_in, "Line 46");

		#5 $display("Finished Register Test Bench. ");
		$display("Error Count: %d", error_count);
		$finish;

	end
	always
		#5 clk = ~clk;

	task Check_Internal_Registers(	input[2:0]	rd,
					input[15:0]	reg_val_exp,
					input[255:0]	message);
		if( test.registers[rd] != reg_val_exp)
		begin
			error_count = error_count + 1;

			$display("Error: %s", message);
			$display("Register Exp %d    : %b", rd, reg_val_exp);
			$display("Register Dest Last: %b", test.rd_last);
			$display("Register Changed 0: %b", test.registers[0]);
			$display("Register Changed 1: %b", test.registers[1]);
			$display("Register Changed 2: %b", test.registers[2]);
			$display("Register Changed 3: %b", test.registers[3]);
			$display("Register Changed 4: %b", test.registers[4]);
			$display("Register Changed 5: %b", test.registers[5]);
			$display("Register Changed 6: %b", test.registers[6]);
			$display("Register Changed 7: %b", test.registers[7]);
		end	
	endtask	

endmodule
