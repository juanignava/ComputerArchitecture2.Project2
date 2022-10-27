module memoryAccess_tb ();

	logic clk, memWriteM, switchStart;
	logic [31:0] pc, A, wd;
	logic [31:0] rd, instruction;

	memoryAccess memory (clk, memWriteM, switchStart, pc, A, wd, rd, instruction);
	
	initial begin
		
		clk = 0; switchStart = 0; #1;
		
		switchStart = 1; #1;
		
		// PC test 1:
		pc = 0; #1
		
		// Writing on RAM test 1:
		A = 150501; #1
		
		memWriteM = 1; wd = 33; #1
		
		// Writing on RAM test 2:
		A = 150500; #1
		
		memWriteM = 1; wd = 45; #1
		
		// Reading from ROM test 1:
		
		A = 500; #1
		
		memWriteM = 0; #1
		
		// Writing on RAM test 3:
		A = 150502; #1
		
		memWriteM = 1; wd = 222; #1
		
		switchStart = 1; #1;
		
		// We need to test Reading from RAM! Some issues may appear.
		
		A = 150500; #1
		
		memWriteM = 0; #1
		
		// Writing on RAM test 4:
		A = 150503; #1
		
		memWriteM = 0; wd = 11; #1
		
		switchStart = 1; #1;

	end
	
	always begin
		clk=!clk; #1;
	end
	
endmodule 