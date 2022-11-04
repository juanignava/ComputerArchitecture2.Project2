module control_unit_tb ();

	logic clk, rst;
	logic [1:0] instruction_type, func;
	logic imm, vector;
	
	logic JumpI, JumpCI, JumpCD, MemToReg, MemWrite, ImmSrc, VectorOp, ALUSrc1, ALUSrc3, RegVWrite, RegSWrite;
	logic [1:0] ALUOp, ALUSrc2;
	
	control_unit control_unit_TB (instruction_type, func,
											rst, imm, vector,
								         JumpI, JumpCI, JumpCD, MemToReg, MemWrite, ImmSrc, VectorOp, ALUSrc1, ALUSrc3, RegVWrite, RegSWrite,
											ALUOp, ALUSrc2);
	
	initial begin
		
		clk = 0;
		rst = 1; 
		rst = 0; 
		
		// --------------- Instrucciones de control ------------------
		
		// SCI
		
		instruction_type = 2'b00;
		func = 2'b00; 
		imm = 1'b0; 
		vector = 1'b0; #2
		
		// SCD
		
		instruction_type = 2'b00;
		func = 2'b01; 
		imm = 1'b0; 
		vector = 1'b0; #2
		
		// SI
		
		instruction_type = 2'b00;
		func = 2'b00; 
		imm = 1'b1; 
		vector = 1'b0; #2
		
		// --------------- Instrucciones de memoria ------------------
		
		// GDR
		
		instruction_type = 2'b01;
		func = 2'b00; 
		imm = 1'b0; 
		vector = 1'b0; #2
		
		// CRG
		
		instruction_type = 2'b01;
		func = 2'b01; 
		imm = 1'b0; 
		vector = 1'b0; #2
		
		// GDRV
		
		instruction_type = 2'b01;
		func = 2'b00; 
		imm = 1'b0; 
		vector = 1'b1; #2
		
		// CRGV
		
		instruction_type = 2'b01;
		func = 2'b01; 
		imm = 1'b0; 
		vector = 1'b1; #2
		
		// ---------------- Instrucciones de datos -------------------
		
		// SUM
		
		instruction_type = 2'b10;
		func = 2'b00; 
		imm = 1'b0; 
		vector = 1'b0; #2
		
		// MULEV
		
		instruction_type = 2'b10;
		func = 2'b00; 
		imm = 1'b0; 
		vector = 1'b1; #2
		
		// DIVEV
		
		instruction_type = 2'b10;
		func = 2'b01; 
		imm = 1'b0; 
		vector = 1'b1; #2
		
		// SUMV
		
		instruction_type = 2'b10;
		func = 2'b10; 
		imm = 1'b0; 
		vector = 1'b1; #2
		
		// SUMI
		
		instruction_type = 2'b10;
		func = 2'b00; 
		imm = 1'b1; 
		vector = 1'b0; #2
		
		// RESI
		
		instruction_type = 2'b10;
		func = 2'b01; 
		imm = 1'b1; 
		vector = 1'b0; #2
		
		// MULI
		
		instruction_type = 2'b10;
		func = 2'b10; 
		imm = 1'b1; 
		vector = 1'b0; #2
		
		// DIVI
		
		instruction_type = 2'b10;
		func = 2'b11; 
		imm = 1'b1; 
		vector = 1'b0; 
		
	end
	
	always begin
		clk=!clk; #1;
	end
	
endmodule