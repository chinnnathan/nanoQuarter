module sim_mem
  #(parameter BITS      = 32,   //bits per word
    parameter ADDRWIDTH = 12)   //2^ADDRWIDTH address locations
   (output reg [BITS-1:0] Q,
    input                 CLK,
    input                 CEN,
    input      [BITS-1:0] WEN,
    input [ADDRWIDTH-1:0] A,
    input      [BITS-1:0] D,
    input           [2:0] EMA,
    input                 GWEN,
    input                 RETN);

  localparam WORDS = (2**ADDRWIDTH); //mem size = ((BITS x WORDS))/8 bytes
  reg [BITS-1:0] mem [0:(2**ADDRWIDTH)-1];
  reg [BITS-1:0] writeEnable;
  reg [BITS-1:0] Dout;
  reg failedAccess;

  always @ (WEN or GWEN) begin
    writeEnable = ~ ({BITS{GWEN}} | WEN);
  end

  always @ (posedge CLK) begin
    if ((A >= WORDS) && (CEN === 1'b0)) begin
      failedAccess = 1;
      Q = ((writeEnable & D) | (~writeEnable & {BITS{1'bx}}));
    end else if ((CEN === 1'b0 && (^A) === 1'bx && ~(|writeEnable)) || (RETN != 1'b1) || (|EMA))
      begin
      failedAccess = 1;
      Q = {BITS{1'bx}};
    end else if (CEN === 1'b0) begin
      failedAccess = 0;
      mem[A] = (mem[A] & ~writeEnable) | (D & writeEnable);
      if (GWEN === 1'b1)
        Q = mem[A];
      else
        Q = ((writeEnable & mem[A]) | (~writeEnable & Q));
    end

    if (failedAccess /*&& ~dut.chromium_core.reset_n*/) begin
      if ((A >= WORDS) && (CEN === 1'b0)) begin
        $display("Time: %0t MEMORY ERROR: Address out of range: FAILED ACCESS!!", $time);
        //stim.sim_error = stim.sim_error + 1;
      end
      if (CEN === 1'b0 && (^A) === 1'bx && |(writeEnable)) begin
        $display("Time: %0t MEMORY ERROR: Indeterminate Address: FAILED WRITE!!", $time);
        //stim.sim_error = stim.sim_error + 1;
      end
      if (RETN != 1'b1) begin
        $display("Time: %0t MEMORY ERROR: RETN input is not supported in this simulation model!", $time);
        //stim.sim_error = stim.sim_error + 1;
        //stim.summarize_connections;
        $finish;
      end
      if (EMA != 3'b000) begin
        $display("Time: %0t MEMORY ERROR: EMA input is not supported in this simulation model!", $time);
        //stim.sim_error = stim.sim_error + 1;
        //stim.summarize_connections;
        $finish;
      end
      $fflush(1);
    end
  end
endmodule
