module memoryController_tb ();

	logic clk, rst, we, VecOp, switchStart, loading;
	logic [31:0] pc, address;
	logic [191:0] wd;
	logic [14:0] switch_regs;
	logic [31:0] instruction;
	logic [191:0] rd;
	
	memoryController memoryController_TB (clk, rst, we, VecOp, switchStart, loading, pc, address, wd, switch_regs, 
														instruction, rd);
	
	initial begin
		
		clk = 0;
		rst = 1; 
		rst = 0; 
		
		// --------------- Probando memorias ------------------
		
		// First test
		
		we = 1'b0;
		VecOp = 1'b1;
		switchStart = 1'b0;
		loading = 1'b1;
		pc = 32'd0;
		address = 32'd500;	
		wd = 192'd255; 
		switch_regs = 14'd0 ;#2;
		
		// Second test
		/*
		we = 1'b1;
		VecOp = 1'b1;
		switchStart = 1'b1; 
		pc = 32'd1;
		address = 32'd1;	
		wd = 192'd256; 
		switch_regs = 14'd0 ;#2;
		*/
		
	end
	
	always begin
		clk=!clk; #100;
	end
	
endmodule