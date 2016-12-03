
/*
*	Nathan Chinn
*	module: APB.v
*	purpose:	Read From file - store into memory
*			Write to Memory
*			Read from Memory
*
*
*/
// iverilog -o working.vpp APB_TB.v && vvp working.vpp && gtkwave APB_TB.vcd
`include "APB.v"
module APB_TB();
	
	reg  		clk;
	reg  		rst;
	reg[16:0] 	paddr;
	reg     	pwrite;
	reg     	psel;
	reg     	penable;
	reg[127:0]	filename;
	reg[31:0] 	pwdata;
	wire		valid;
	wire[31:0] 	prdata;

	integer	i;	

	APB test(	.clk(clk),		.rst(rst),	
			.paddr(paddr),		.pwrite(pwrite),
			.psel(psel),		.penable(penable),
			.pwdata(pwdata),	.prdata(prdata),
			.filename(filename),
			.valid(valid)
		);

	initial begin
		$dumpfile("APB_TB.vcd");
		$dumpvars(0, APB_TB);

		rst = 1'b1; clk = 1'b0;
		filename = "data.bin";

		@(negedge clk);
			rst = 1'b0;

		$display("Starting Read Testing");
		@(negedge clk);
			penable = 1'b1; 
			psel 	= 1'b1; 
			pwrite 	= 1'b0;


		for(i=0; i<10; i=i+1)
		begin
				paddr = i;
				penable = 1'b0; 
			@(negedge clk);
				penable = 1'b1;
				$display("1 CLK cycle of Junk");
			@(negedge clk);
				$display("Output Data address[%d]: %b", paddr, prdata);
				$display("Memory Data address[%d]: %b", paddr, test.mem[paddr]);
		end
		$display("End Read Testing");

		$display("Starting Write Testing");
		@(negedge clk);
			penable = 1'b1; 
			psel 	= 1'b1; 
			pwrite 	= 1'b1;
			pwdata  = 32'hAAAA_AAAA;


		for(i=0; i<10; i=i+1)
		begin
				paddr = i;
				penable = 1'b0; 
			@(negedge clk);
				penable = 1'b1;
				$display("1 CLK cycle of Junk");
				$display("APB State: %b", test.apb_st);
			@(negedge clk);
				$display("APB State: %b", test.apb_st);
				$display("Writing address[%d]: %b", paddr, pwdata);
				$display("Memory  address[%d]: %b", paddr, test.mem[paddr]);
		end
		$display("End Write Testing");
		

		#10 $display("Finished APB Test");
		$finish;
	end
	always
		#5 clk = ~clk;
endmodule
