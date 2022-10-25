module alu_6lanes #(parameter V = 192, S = 32) 
						 (input logic [V-1:0] A, B,
						  input logic op,
						  input logic [2:0] sel,
						  output logic [V-1:0] C,
						  output flagZ);
						  	
	//reg [V-1:0] alu_out_temp = 192'b00000000000000000000000000000000 00000000000000000000000000000000 00000000000000000000000000000000 00000000000000000000000000000000 00000000000000000000000000000000 00000000000000000000000000000000;
	//reg [V-1:0] alu_out_temp = 192'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	reg [V-1:0] alu_out_temp;
	
	//reg [S-1:0] A_aux;
	//reg [S-1:0] B_aux;
	
	reg [S-1:0] C0;
	reg [S-1:0] C1;
	reg [S-1:0] C2;
	reg [S-1:0] C3;
	reg [S-1:0] C4;
	reg [S-1:0] C5;
	
	logic flagZ_aux;
	
	
	always @(*)
	
		case (op)
		
			// case operación escalar
			1'b0:
						
				//alu_out_temp = A + B;
				
				//A_aux = A[S-1:0];
				//B_aux = B[S-1:0];				
				
				alu alu_0 (A[31:0], B[31:0], sel, C0, flagZ);
				
				// crear resultado de la alu_6lanes
				alu_out_temp = alu_out_temp + C0;
				
			// case operación vectorial
			1'b1:
			
				case (sel)
				
					// case multiplicación escalar vector
					2'b00:
						
						alu alu_0 (A[31:0], B[31:0], 2'b10, C0, flagZ);				
						alu alu_1 (A[63:32], B[31:0], 2'b10, C1, flagZ_aux);				
						alu alu_2 (A[95:64], B[31:0], 2'b10, C2, flagZ_aux);				
						alu alu_3 (A[127:96], B[31:0], 2'b10, C3, flagZ_aux);				
						alu alu_4 (A[159:128], B[31:0], 2'b10, C4, flagZ_aux);				
						alu alu_5 (A[191:160], B[31:0], 2'b10, C5, flagZ_aux);
						
					// case división escalar vector
					2'b01:
					
						alu alu_0 (A[31:0], B[31:0], 2'b11, C0, flagZ);				
						alu alu_1 (A[63:32], B[31:0], 2'b11, C1, flagZ_aux);				
						alu alu_2 (A[95:64], B[31:0], 2'b11, C2, flagZ_aux);				
						alu alu_3 (A[127:96], B[31:0], 2'b11, C3, flagZ_aux);				
						alu alu_4 (A[159:128], B[31:0], 2'b11, C4, flagZ_aux);				
						alu alu_5 (A[191:160], B[31:0], 2'b11, C5, flagZ_aux);
		
					// case suma vector vector
					2'b10:
					
						alu alu_0 (A[31:0], B[31:0], 2'b00, C0, flagZ);				
						alu alu_1 (A[63:32], B[63:32], 2'b00, C1, flagZ_aux);				
						alu alu_2 (A[95:64], B[95:64], 2'b00, C2, flagZ_aux);				
						alu alu_3 (A[127:96], B[127:96], 2'b00, C3, flagZ_aux);				
						alu alu_4 (A[159:128], B[159:128], 2'b00, C4, flagZ_aux);				
						alu alu_5 (A[191:160], B[191:160], 2'b00, C5, flagZ_aux);
					
				endcase 
							
				// crear resultado de la alu_6lanes
				alu_out_temp = alu_out_temp + C5;	
				alu_out_temp = alu_out_temp << 32;
				
				alu_out_temp = alu_out_temp + C4;	
				alu_out_temp = alu_out_temp << 32;
				
				alu_out_temp = alu_out_temp + C3;	
				alu_out_temp = alu_out_temp << 32;
				
				alu_out_temp = alu_out_temp + C2;	
				alu_out_temp = alu_out_temp << 32;
				
				alu_out_temp = alu_out_temp + C1;	
				alu_out_temp = alu_out_temp << 32;
				
				alu_out_temp = alu_out_temp + C0;

		endcase

	// resultado de la alu_6lanes
	assign C = alu_out_temp;
	
endmodule
