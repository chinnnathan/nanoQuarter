// Simulation RAM model

// BEHAVIORAL VERSION THAT SUPPORTS 32-BIT LOAD TASK

module hdsd1_1024x32cm8 
  (output  [31:0] Q,
   input         CLK,
   input         CEN,
   input   [3:0] WEN,
   input   [9:0] A,
   input  [31:0] D,
   input   [2:0] EMA,
   input         GWEN,
   input         RETN);

  localparam BITS      = 32;   //bits per word
  localparam ADDRWIDTH = 10;
  localparam WORDS = (2**ADDRWIDTH); 
  integer i;

  wire [BITS-1:0] Q_out;
  reg [1000:0]    s1; //string name holder
  
  initial begin //initialize the memory
    if ($value$plusargs("EXPPHY5MEM=%s", s1)) begin
      $readmemh (s1, mem.mem, 0, WORDS-1);
    end
    else begin // if no file provided
      for (i = 0; i < WORDS; i = i + 1)
        mem.mem[i] = {BITS{1'b1}};
    end
  end
  
  sim_mem #(BITS, ADDRWIDTH) mem
    (.CLK  (CLK),
     .CEN  (CEN),
     .A    (A),
     .GWEN (GWEN),
     .WEN  ({{8{WEN[3]}},{8{WEN[2]}},{8{WEN[1]}},{8{WEN[0]}}}),
     .D    (D),
     .Q    (Q_out),
     .EMA  (EMA),
     .RETN (RETN));

  assign Q = Q_out;

  task load_memory;
    input [8*90:1] memory_file;
  begin
    $readmemh (memory_file, mem.mem, 0, WORDS-1);
  end
  endtask

endmodule
