module APB_Arbiter
#(
  parameter ADDRWIDTH = 10,
  parameter DATAWIDTH = 32
)
(
  input                        Q,
  input                        clk,
  input 					   CEN,
  input                        reset_N,
  input        [ADDRWIDTH-1:0] paddr,
  input                        pwrite,
  input                        psel,
  input                        penable,
  input        [DATAWIDTH-1:0] pwdata,
  input                  [2:0] EMA,
  input                        GWEN,
  input                        RETN,
  output reg                   WRITE_FLAG,
  output reg    [DATAWIDTH-1:0] prdata);

reg [15:0] memory; 
reg [1:0] apb_st;
reg [1:0] APB_SETUP = 0;
reg [1:0] WRITE_ENABLE = 1;
reg [1:0] READ_ENABLE = 2;

hdsd1_1024x32cm8 hdsd1_1024x32cm8(.Q(Q), .CLK(clk), .CEN(CEN), .WEN(WRITE_ENABLE), .A(ADDRWIDTH), .D(DATAWIDTH), .EMA(EMA), .GWEN(GWEN), .RETN(RETN));

// APB_SETUP -> ENABLE
always @(negedge reset_N or posedge clk) begin
  if (reset_N == 0) begin // Reset everything to 0
    apb_st <= 0;
	prdata <= 0;
  end

  else begin
    case (apb_st)
      APB_SETUP : begin // Setup APB

		 // clear the prdata (Data Read)
        prdata <= 0;
		
        // Enable Write or Read
        if (psel && !penable) begin
          if (pwrite) begin
            apb_st <= WRITE_ENABLE; // Enable Write
          end

          else begin
            apb_st <= READ_ENABLE; // Enable Read 
          end
        end
      end

      WRITE_ENABLE : begin
        // Write pwdata to memory
        if (psel && penable && pwrite) begin
          memory[paddr] <= pwdata;
        end
		
		WRITE_FLAG <= 1;
        // return to APB_SETUP
        apb_st <= APB_SETUP;
      end

      READ_ENABLE : begin
        // read prdata from memory
        if (psel && penable && !pwrite) begin
          prdata <= memory[paddr];
        end
		
		WRITE_FLAG <= 0;
        // return to APB_SETUP
        apb_st <= APB_SETUP;
      end
    endcase
  end
  
  
end 


endmodule
