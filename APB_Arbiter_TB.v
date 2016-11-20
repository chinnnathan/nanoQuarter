`include "APB_Arbiter.v"
module APB_Arbiter_TB();
	reg  Q;
	reg  clk;
	reg CEN;
	reg  reset_N;
	reg [15:0] paddr;
	reg     pwrite;
	reg     psel;
	reg     penable;
	reg     [15:0] pwdata;
	reg     [2:0]  EMA;
	reg     GWEN;
	reg 	RETN;
	wire    WRITE_FLAG;
	wire    [15:0] prdata;
	
	APB_Arbiter APB_Arbiter(.Q(Q), .clk(clk), .CEN(CEN), .reset_N(reset_N), .paddr(paddr),
							.pwrite(pwrite), .psel(psel), .penable(penable), .pwdata(pwdata),
							.EMA(EMA), .GWEN(GWEN), .RETN(RETN), .WRITE_FLAG(WRITE_FLAG), .prdata(prdata));

	 initial begin
		 clk = 1'b0;
		 forever #10 clk = !clk;
	end
	
	initial begin
		reset_N = 1'b1;
		@(negedge clk);
		@(negedge clk);
		reset_N = 1'b0;
		@(negedge clk);
		penable = 0; psel = 1; pwrite = 1; paddr = 15'b0000000000000001; pwdata = 15'b1111111111111111;// Write
		@(negedge clk);
		penable = 0; psel = 1; pwrite = 1; paddr = 15'b0000000000000001; pwdata = 15'b1111111111111111;// Write
		@(negedge clk);
		penable = 1; psel = 1'b1; pwrite = 1'b1; paddr = 15'b0000000000000001; pwdata = 15'b1111111111111111;// Write
		@(negedge clk);
		penable = 0; psel = 1'b1; pwrite = 1'b0; paddr = 15'b0000000000000001;  // Read
		@(negedge clk);
	end
endmodule
