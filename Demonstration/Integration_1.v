
/*
* 	Nathan Chinn, Bryan Lee
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
`include "Registers.v"
//`include "APB.v"
`include "Faux_Inst.v"
module Integration1( 	input 			clk,
						rst,
			input wire[31:0]	PCNI,
			input wire[15:0]	mmuxout,
			input wire		regwrite,

			output wire [4:0] 	boff,
			output wire [2:0] 	func,
			output wire [1:0] 	shamt,
			output wire [1:0] 	op,
			output wire [7:0] 	idata,

			output wire[31:0]	PC,	
			output wire 		jmp,
				        	bne,
						memRead,
				       		memWrite,
						valid,
		     	output wire [15:0] 	reg1data,	
						reg2data,
		      	output wire [2:0] 	ALU_func,
			input wire		write_reg,

			// Below Here should be internal
			input wire[15:0]	mem_data
		
		);

	//prefetch module
	wire [15:0] inst;				
	wire [31:0] exInst;
	wire enable;
	wire read;
	wire valid_im;
	localparam instruction_file = "instdata.bin";

	//pc and pc_mux module
	wire [31:0] PC_mux_out;
	wire [31:0] PC_out;
	wire [31:0] PC_im;
	wire stall_flg;

	//main control module
	wire jmp_flg, brnch_flg, nop_flg, 
		  memRd_flg, memWrt_flg;

	//ALUcontrol
	wire jr;
	wire [2:0] alu_funct; // alucontrol output function


	// PCMUX
	//  Stall flag High keeps PC at same Value
	assign PC_mux_out = stall_flg ? PC : PCNI;

	assign idata = inst[10:2];
	assign op = inst[15:14];
	assign func = inst[2:0];
	assign boff = inst[7:3];
	assign shamt = inst[4:3];

	assign pwrite = 1'b0;

	// PC
	// On reset Set PC to 0
	// Else step PC to next PC
	PC PC1(				.clk(clk),			.rst(rst),
					.new_PC(PC_mux_out),		.PC_out(PC)
				);

	Registers Registers(		.clk(clk),
					.rst(rst),
					.write_reg(regwrite),
					.rs1(inst[13:11]),
					.rs2(inst[10:8]),
					.rd(inst[7:5]),
					.data_in(mmuxout),
					.reg1data(reg1data),
					.reg2data(reg2data)
				);

	
	MainControl MainControl(	.stall_flg(stall_flg),		.opcode(inst[15:14]),
					.funct(inst[2:0]),		.jmp_flg(jmp),
					.brnch_flg(bne),		.nop_flg(nop_flg),
					.memRd_flg(memRead),		.memWrt_flg(memWrite)
				);

	StallUnit StallUnit(		.clk(clk),			.rst(rst),
					.opcode(inst[15:14]),		.rs1(inst[13:11]),
					.rs2(inst[10:8]),		.rd(inst[7:5]),
					.pc_old(PC_out),		.stall_flg(stall_flg)
				);

	//APB 	InstructionMemory(	.clk(clk),		.rst(rst),	
	//				.paddr(PC_im),		.pwrite(pwrite),
	//				.psel(read),		.penable(enable),
	//				.pwdata(pwdata),	.prdata(exInst),
	//				.filename(instruction_file),
	//				.valid(valid_im)
	//			);
	
	Faux_Inst InstructionMemory(	.clk(clk),		.rst(rst),
					.addr(PC_im),		.out_inst(exInst),
					.valid(valid)
				);

	PrefetchBuffer PrefetchBuffer(	.clk(clk),			.rst(rst),
					.write(valid_im),		.inst1(exInst[31:16]),
					.inst2(exInst[15:0]),     	.inst(inst),
					.stall_flg(stall_flg),		.PC_in(PC),
					.enable(enable),		.read(read),
					.PC_out(PC_im)
				);
endmodule
