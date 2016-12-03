The link to the github repository is: https://github.com/chinnnathan/nanoQuarter.git

To run: Import all verilog code into whatever HDL system you prefer.

Prefered Method:
	1) Download Icarus iverilog
	2) Set path to iverilog.exe to path variable: 
		C:\Program Files\iverilog\bin -> add to path
	3) Ensure that verilog file will compile: 
		1 - iverilog -o Module_Name Module_Name.v
		2 - vvp Module_Name
		Step 1 will compile the verilog module
		Step 2 will create a vcd file which can be viewed in GTKWave
	4) To look at waveform
		1 - From GUI
			* find where gtkwave.exe is located (C:\Program Files\iverilog\gtkwave\bin\gtkwave.exe)
			* File -> Open New Tab -> Locate vcd File
			* Click on module name in SST window
			* Highlight all Signals and click insert button (click and hold shift)
		2 - From Command Line
			* add to path varible -> C:\Program Files\iverilog\gtkwave\bin 
			* run Command: gtkwave Module_Name.vcd
			* Click on module name in SST window
			* Highlight all Signals and click insert button (click and hold shift)			


Contact Nathan for any other info at: nchinn@uccs.edu
