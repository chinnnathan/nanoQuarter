
/*
* 	Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Fake Memory
*	Purpose: Holding fake memory for Demo
*
*
*/

module Faux_DM(		input clk,
			input rst,
			input read,
			input write,
			input [15:0] addr,
			input[15:0] write_mem,
			output reg valid,
			output reg [31:0]out_inst
		);
	reg [31:0] instructions[50:0]; // room for 50 hard coded instructions
	always @ (posedge clk or posedge rst)
	begin
		if (rst == 1)
		begin
			instructions[0] <= 0000000000000000_0000000000000000;
			instructions[1] <= 0100100000100000_0100000000000001;
			instructions[2] <= 0011101001101000_0010111011111001;
			instructions[3] <= 0000101001100010_0000001010010011;
			instructions[4] <= 0000110010100100_0001001111000110;
			instructions[5] <= 0000000101001101_0100100000101010;
			instructions[6] <= 0100001010110000_0110111101101001;
			instructions[7] <= 0111010101011011_1010100000000001;
			instructions[8] <= 1000000000101000_1100101001110000;
			instructions[9] <= 0110100000000001_1010000110110000;
			instructions[10]<= 0000101001100001_1111111111111111;		

			out_inst <= 0;
		end
		else
		begin
			if(read == 1)
			begin
				out_inst <= instructions[addr];
				valid <= 1;
			end
			if(write ==1)
			begin
				instructions[addr] <= write_mem;
			end


		end
	end
endmodule

