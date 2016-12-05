/*
*	Nathan Chinn
*	module: APB.v
*	purpose:	Read From file - store into memory
*			Write to Memory
*			Read from Memory
*
*
*/
module APB (
		  input         clk,
		  input        	rst,
		  input[31:0] 	paddr,
		  input         pwrite,
		  input         psel,
		  input         penable,
		  input[31:0] 	pwdata,
		  input[127:0]  filename,

		  output reg		valid,
		  output reg[31:0] 	prdata
	);

reg [31:0] mem [255:0];

reg [1:0] apb_st;
localparam SETUP 	= 2'b00;
localparam W_ENABLE 	= 2'b01;
localparam R_ENABLE 	= 2'b10;


// Load Data From File
initial begin
	$readmemb(filename, mem);
end

// SETUP -> ENABLE
always @(posedge rst or posedge clk) begin
  if (rst == 1) begin
    apb_st <= 0;
    prdata <= 0;
    valid <= 0;
  end

  else begin
    case (apb_st)
      SETUP : begin
        // clear the prdata
        prdata <= 32'hFFFF_FFFF;
	valid <= 0;
  	$writememb(filename, mem);

        // Move to ENABLE when the psel is asserted
        if (psel && !penable) begin
          if (pwrite) begin
            apb_st <= W_ENABLE;
          end

          else begin
            apb_st <= R_ENABLE;
          end
        end
      end

      W_ENABLE : begin
        // write pwdata to memory
        if (psel && penable && pwrite) begin
          mem[paddr] <= pwdata;
        end

        // return to SETUP
        apb_st <= SETUP;
      end

      R_ENABLE : begin
        // read prdata from memory
        if (psel && penable && !pwrite) begin
          prdata <= mem[paddr];
	  valid <= 1;
        end

        // return to SETUP
        apb_st <= SETUP;
      end
    endcase
  end
end 


endmodule
