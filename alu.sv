module alu #(parameter V = 192, S = 32) 
			   (input logic [S-1:0] A, B,				 
				 input logic [2:0] sel,
				 output logic [S-1:0] C,
				 output flagZ);
						  	
	reg [S-1:0] alu_out_temp;
	
	always @(*)
	
		case (sel)
		
			// case suma
			2'b00: alu_out_temp = A + B; 
			
			// case resta
			2'b01: alu_out_temp = A - B;
			
			// case multiplicación
			2'b10: alu_out_temp = A * B;
			
			// case división
			2'b11: alu_out_temp = A / B;
			
			default: alu_out_temp = A + B; 
		
		endcase 
		
	// resultado de la alu
	assign C = alu_out_temp;
	
	// banderas
	assign flagZ = (alu_out_temp == 31'd0);	// bandera de cero (Z)
	
endmodule
