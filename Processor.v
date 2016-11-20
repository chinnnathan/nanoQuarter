module processor(input clk, input rst);

reg[31:0] exInst, PCNI;
reg Mmuxout, regWrite;
reg[7:0] jtarget_in;
reg[5:0] memaddr_in;
reg[4:0] boffset_in;
reg[2:0] funct_in;
reg[2:0] ALUfunct_in;
reg[1:0] op_in, shamt_in;
reg bne_in;
reg jr_in;
reg[31:0] PC_in;
reg[15:0] memdata;

wire[1:0] shamt;
wire PC, jmp, bne, memRead, memWrite, valid;
wire[15:0] reg1data, reg2data;
wire[2:0] ALU_func;
wire[6:0] iVal;
wire[15:0] mem_data;
wire write;

Integration1 Integration1(.clk(clk), .rst(rst), .exInst(exInst), .PCNI(PCNI),
			               .Mmuxout(Mmuxout), .regWrite(regWrite), .shamt(shamt),
						   .PC(PC),	.jmp(jmp), .bne(bne), .memRead(memRead),
				       	   .memWrite(memWrite), .valid(valid), .reg1data(reg1data),	
						   .reg2data(reg2data), .ALU_func(ALU_func), .iVal(iVal), 
						   .mem_data(mem_data),	.write(write));
						   
Integration2 Integration2(.clk(clk), .rst(rst), .reg1data_in(reg1data),
						  .reg2data_in(reg2data), .jtarget_in(jtarget_in),	 
			              .memaddr_in,	.boffset_in(boffset_in), .funct_in(funct_in),	
						  .ALUfunct_in(ALUfunct_in), .op_in(op_in), .shamt_in(shamt_in),
						   .bne_in(bne_in),	.jr_in(jr_in), .PC_in(PC_in), .memdata(memdata));
						   
// Control signals need added
// APB goes where???? memdata???? Prefetch???

endmodule
