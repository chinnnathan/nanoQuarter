////////////////////////////////////////////////////////////////////////////////
//
// sram_8kx16.v
//
// 8Kx16 SRAM model
//
// author:  Greg Tabor
// email:   greg.tabor@dalsemi.com
// started: 25-Mar-2007
//
////////////////////////////////////////////////////////////////////////////////

module sram_8kx16 (

  clk,
  addr,
  we,
  wdata,

  rdata
);

input         clk;
input  [12:0] addr;
input   [1:0] we;
input  [15:0] wdata;

output [15:0] rdata;

// wires and regs

parameter D = 1;

reg  [15:0] temp_value;
reg  [15:0] rdata;

// the memory array (byte addressable)

reg [15:0] mem_array [8191:0];

// write logic

always @(posedge clk)
  if (we[0])
  begin
    temp_value[15:0] = mem_array[addr];
    temp_value[7:0] = wdata[7:0];
    mem_array[addr] = temp_value[15:0];
  end

always @(posedge clk)
  if (we[1])
  begin
    temp_value[15:0] = mem_array[addr];
    temp_value[15:8] = wdata[15:8];
    mem_array[addr] = temp_value[15:0];
  end

// read logic

always @(posedge clk) rdata[15:0] <= #D mem_array[addr];

// Icarus does not support variable indexes into strings, so this hack allows it:

function [8*64:1] concatenate_string;
  input [8*128:1] string1;
  input  [8*64:1] string2;
  input    [31:0] i;
  reg   [8*64:1] cat_string;
begin
  case (i)
    64 : cat_string = {string1,string2[64*8:1]};
    63 : cat_string = {string1,string2[63*8:1]};
    62 : cat_string = {string1,string2[62*8:1]};
    61 : cat_string = {string1,string2[61*8:1]};
    60 : cat_string = {string1,string2[60*8:1]};
    59 : cat_string = {string1,string2[59*8:1]};
    58 : cat_string = {string1,string2[58*8:1]};
    57 : cat_string = {string1,string2[57*8:1]};
    56 : cat_string = {string1,string2[56*8:1]};
    55 : cat_string = {string1,string2[55*8:1]};
    54 : cat_string = {string1,string2[54*8:1]};
    53 : cat_string = {string1,string2[53*8:1]};
    52 : cat_string = {string1,string2[52*8:1]};
    51 : cat_string = {string1,string2[51*8:1]};
    50 : cat_string = {string1,string2[50*8:1]};
    49 : cat_string = {string1,string2[49*8:1]};
    48 : cat_string = {string1,string2[48*8:1]};
    47 : cat_string = {string1,string2[47*8:1]};
    46 : cat_string = {string1,string2[46*8:1]};
    45 : cat_string = {string1,string2[45*8:1]};
    44 : cat_string = {string1,string2[44*8:1]};
    43 : cat_string = {string1,string2[43*8:1]};
    42 : cat_string = {string1,string2[42*8:1]};
    41 : cat_string = {string1,string2[41*8:1]};
    40 : cat_string = {string1,string2[40*8:1]};
    39 : cat_string = {string1,string2[39*8:1]};
    38 : cat_string = {string1,string2[38*8:1]};
    37 : cat_string = {string1,string2[37*8:1]};
    36 : cat_string = {string1,string2[36*8:1]};
    35 : cat_string = {string1,string2[35*8:1]};
    34 : cat_string = {string1,string2[34*8:1]};
    33 : cat_string = {string1,string2[33*8:1]};
    32 : cat_string = {string1,string2[32*8:1]};
    31 : cat_string = {string1,string2[31*8:1]};
    30 : cat_string = {string1,string2[30*8:1]};
    29 : cat_string = {string1,string2[29*8:1]};
    28 : cat_string = {string1,string2[28*8:1]};
    27 : cat_string = {string1,string2[27*8:1]};
    26 : cat_string = {string1,string2[26*8:1]};
    25 : cat_string = {string1,string2[25*8:1]};
    24 : cat_string = {string1,string2[24*8:1]};
    23 : cat_string = {string1,string2[23*8:1]};
    22 : cat_string = {string1,string2[22*8:1]};
    21 : cat_string = {string1,string2[21*8:1]};
    20 : cat_string = {string1,string2[20*8:1]};
    19 : cat_string = {string1,string2[19*8:1]};
    18 : cat_string = {string1,string2[18*8:1]};
    17 : cat_string = {string1,string2[17*8:1]};
    16 : cat_string = {string1,string2[16*8:1]};
    15 : cat_string = {string1,string2[15*8:1]};
    14 : cat_string = {string1,string2[14*8:1]};
    13 : cat_string = {string1,string2[13*8:1]};
    12 : cat_string = {string1,string2[12*8:1]};
    11 : cat_string = {string1,string2[11*8:1]};
    10 : cat_string = {string1,string2[10*8:1]};
    9  : cat_string = {string1,string2[9 *8:1]};
    8  : cat_string = {string1,string2[8 *8:1]};
    7  : cat_string = {string1,string2[7 *8:1]};
    6  : cat_string = {string1,string2[6 *8:1]};
    5  : cat_string = {string1,string2[5 *8:1]};
    4  : cat_string = {string1,string2[4 *8:1]};
    3  : cat_string = {string1,string2[3 *8:1]};
    2  : cat_string = {string1,string2[2 *8:1]};
    1  : cat_string = {string1,string2[1 *8:1]};
    default: cat_string = {string1,string2};
  endcase
  concatenate_string = cat_string;
end
endfunction

// pre-load memory with contents of mem file

task load_memory;
  input [8*64:1] filename;
  reg [8*128:1] long_filename;
  reg [8*64:1] short_filename;
  reg [8*64:1] cat_filename;
  integer i,done;
begin
  mem_array[0] = 16'hDEAD;
  mem_array[1] = 16'hDEAD;
  mem_array[2] = 16'hDEAD;
  mem_array[3] = 16'hDEAD;
  $display("Time: %0t Trying to load memory array from local file %0s",$time,filename);
  $readmemh(filename,mem_array);
  if ((mem_array[0] == 16'hDEAD)
   && (mem_array[1] == 16'hDEAD)
   && (mem_array[2] == 16'hDEAD)
   && (mem_array[3] == 16'hDEAD))
  begin
    // try long filepath...

`ifdef icarus
    // icarus doesn't concatenate strings nicely; this hack fixes it

    $display("RUNNING MEMFILE HACK FOR ICARUS");
    $display("Time: %0t Local file not found, looking at ../asm/memfiles",$time,long_filename);

    i=32; done=0;
    while ((!done) && (i>1))
    begin
      long_filename = {"../asm/memfiles/"};
      cat_filename = concatenate_string(long_filename,filename,i);
      //$display("Trying string concatenation variant: %0s",cat_filename);
      $readmemh(cat_filename,mem_array);
      if ((mem_array[0] == 16'hDEAD)
       && (mem_array[1] == 16'hDEAD)
       && (mem_array[2] == 16'hDEAD)
       && (mem_array[3] == 16'hDEAD))
      begin
        i=i-1;
      end else
      begin
        $display("Time: %0t Memory successfully loaded by file %0s",$time,cat_filename);
        done=1;
      end
    end

    if ((mem_array[0] == 16'hDEAD)
     && (mem_array[1] == 16'hDEAD)
     && (mem_array[2] == 16'hDEAD)
     && (mem_array[3] == 16'hDEAD))
    begin
      $display("Time: %0t FATAL ERROR - Did not successfully load the referenced memory file anywhere",$time);
      $finish;
    end

`else

    long_filename = {"../asm/memfiles/",filename};
    $display("Time: %0t Local file not found, looking at %0s",$time,long_filename);
    $readmemh(long_filename,mem_array);
    if ((mem_array[0] == 16'hDEAD)
     && (mem_array[1] == 16'hDEAD)
     && (mem_array[2] == 16'hDEAD)
     && (mem_array[3] == 16'hDEAD))
    begin
      $display("Time: %0t FATAL ERROR - Could not find the referenced memory file anywhere: %0s",$time,filename);
      $finish;
    end else
    begin
      $display("Time: %0t Memory successfully loaded by file %0s",$time,long_filename);
    end

`endif

  end else
  begin
    $display("Time: %0t Memory successfully loaded by local file %0s",$time,filename);
  end
end
endtask

endmodule
