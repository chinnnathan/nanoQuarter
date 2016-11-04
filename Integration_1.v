
/*
* 	Bryan Lee - Edited: Nathan Chinn
* 	Minion CPU - NanoQuarter
*
*	Module:  Integration_2.v
*	Purpose: Second stage of the integration Pipeline
*
*
*/
`include "Prefetch_Buffer.v"
`include "PC_MUX.v"
`include "PC.v"
`include "main_control.v"
`include "Stall_Unit.v"
`include "ALU_Control.v"
`include "Stage_1.v"
`include "registers.v"
module Integration1( 	input 			clk,
						rst,
			input wire 		[31:0] exInst,
						PCNI,
			input wire		Mmuxout,
						regWrite,

			output wire [1:0] 	shamt,

			output reg 		PC,	
						jmp,
				        	bne,
						memRead,
				       		memWrite,
						valid,
		     	output reg [15:0] 	reg1data,	
						reg2data,
		      	output reg [2:0] 	ALU_func,
			output reg [6:0] 	iVal,

			// Below Here should be internal	
			input wire		wp
		
		);

	//prefetch module
	wire [15:0] inst;				
	//wire wp_;

	//pc and pc_mux module
	wire [31:0] PC_mux_out;
	wire [31:0] PC_out;
	wire stall_flg;

	//main control module
	wire jmp_flg, brnch_flg, nop_flg, 
		  memRd_flg, memWrt_flg;

	//ALUcontrol
	wire jr;
	wire [2:0] alu_funct; // alucontrol output function

	PrefetchBuffer PrefetchBuffer(	.clk(clk),			.rst(rst),
					.wp(wp),			.inst1(exInst[15:0]),
					.inst2(exInst[31:16]),     	.inst(inst)
				);

	// PCMUX
	//  Stall flag High keeps PC at same Value
	assign PC_mux_out = stall_flg ? PC : PCNI;

	// PC
	// On reset Set PC to 0
	// Else step PC to next PC
	PC PC1(				.clk(clk),			.rst(rst),
					.new_PC(PC_mux_out),		.PC_out(PC_out)
				);


	MainControl MainControl(	.stall_flg(stall_flg),		.opcode(inst[15:14]),
					.funct(inst[2:0]),		.jmp_flg(jmp_flg),
					.brnch_flg(brnch_flg),		.nop_flg(nop_flg),
					.memRd_flg(memRd_flg),		.memWrt_flg(memWrt_flg)
				);

	StallUnit StallUnit(		.clk(clk),			.rst(rst),
					.opcode(inst[15:14]),		.rs1(inst[13:11]),
					.rs2(inst[10:8]),		.rd(inst[7:5]),
					.pc_old(PC_out),		.pc_new(PC_out),
					.stall_flg(stall_flg)
				);

	ALUControl ALUControl(		.inst(inst),			.func(alu_funct),
					.shamt(shamt),			.jr(jr)
				);
	Registers Register(		.clk(clk),			.rst(rst),
			   		.rs1(rs1),			.rs2(rs2),
			   		.rd(rd),			.data_in(data_in),
					.wp(wp),			.reg1data(reg1data),
			   		.reg2data(reg2data)
			  	);
	
endmodule
