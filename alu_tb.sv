module alu_tb();

	//logic clk;
	logic [191:0] A, B;
	logic op;
	logic [1:0] sel;
	logic [191:0] C;
	logic flagZ;

	alu_6lanes alu_TB (A, B, op, sel, C, flagZ);
	
	initial begin
		
		// test escalar
		op = 0;
	
		// test suma		
		A = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111;		
		B = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011;		
		sel = 2'b00;
		#2;
				
		// test resta		
		A = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111;		
		B = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011;
		sel = 2'b01;
		#2;
		
		// test multiplicación		
		A = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111;		
		B = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011;
		sel = 2'b10;
		#2;
		
		// test división		
		A = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111;		
		B = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011;
		sel = 2'b11;
		#2;
				
		// test bandera Zero
		A = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011;		
		B = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011;
		sel = 2'b01;
		#2;	
		
		// test vectorial
		op = 1;
				
		// test multiplicación escalar vector
		A = 192'b000000000000000000000000000001100000000000000000000000000000010100000000000000000000000000000100000000000000000000000000000000110000000000000000000000000000001000000000000000000000000000000001;
		B = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011;
		sel = 2'b00;
		#2;
		
		// test división escalar vector
		A = 192'b000000000000000000000000000001100000000000000000000000000000010100000000000000000000000000000100000000000000000000000000000000110000000000000000000000000000001000000000000000000000000000000001;
		B = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011;
		sel = 2'b01;
		#2;
		
		// test suma vector vector
		A = 192'b000000000000000000000000000001100000000000000000000000000000010100000000000000000000000000000100000000000000000000000000000000110000000000000000000000000000001000000000000000000000000000000001;
		B = 192'b000000000000000000000000000001100000000000000000000000000000010100000000000000000000000000000100000000000000000000000000000000110000000000000000000000000000001000000000000000000000000000000001;
		sel = 2'b10;	
	
	end
	
endmodule
