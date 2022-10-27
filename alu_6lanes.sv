module alu_6lanes #(parameter V = 192, S = 32) 
						  (input [V-1:0] A, B,
						   input op,
						   input [1:0] sel,
						   output [V-1:0] C,
						   output flagZ);

	reg [V-1:0] alu_out_temp = 192'd0;
	
	reg [S-1:0] C0;
	reg [S-1:0] C1;
	reg [S-1:0] C2;
	reg [S-1:0] C3;
	reg [S-1:0] C4;
	reg [S-1:0] C5;
	
	logic flagZ_aux = 0;
		
	always @(*)
	
				case (op)

			// case operación escalar
			1'b0:			
				
				case (sel)
		
					// case suma
					2'b00:
					
						begin
						
							alu_out_temp = A[31:0] + B[31:0];
						
						end
					
					// case resta
					2'b01:
					
						begin
						
							alu_out_temp = A[31:0] - B[31:0];
							
							flagZ_aux = (alu_out_temp == 31'd0);
							
						end
					
					// case multiplicación
					2'b10:
					
						begin
						
							alu_out_temp = A[31:0] * B[31:0];
							
						end
					
					// case división
					2'b11:
					
						begin
						
							alu_out_temp = A[31:0] / B[31:0];
							
						end
					
					default:
					
						begin
						
							alu_out_temp = A[31:0] + B[31:0];
							
						end
				
				endcase
				
			// case operación vectorial
			1'b1:
			
				case (sel)
				
					// case multiplicación escalar vector
					2'b00: begin
					
						C0 = A[31:0] * B[31:0];
						C1 = A[63:32] * B[31:0];
						C2 = A[95:64] * B[31:0];
						C3 = A[127:96] * B[31:0];
						C4 = A[159:128] * B[31:0];
						C5 = A[191:160] * B[31:0];
						
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
						
						end
						
					// case división escalar vector
					2'b01: begin
					
						C0 = A[31:0] / B[31:0];
						C1 = A[63:32] / B[31:0];
						C2 = A[95:64] / B[31:0];
						C3 = A[127:96] / B[31:0];
						C4 = A[159:128] / B[31:0];
						C5 = A[191:160] / B[31:0];
						
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
						
						end
		
					// case suma vector vector
					2'b10: begin
					
						C0 = A[31:0] + B[31:0];
						C1 = A[63:32] + B[63:32];
						C2 = A[95:64] + B[95:64];
						C3 = A[127:96] + B[127:96];
						C4 = A[159:128] + B[159:128];
						C5 = A[191:160] + B[191:160];
						
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
						
						end
						
					default:
					
						begin
						
							C0 = A[31:0] + B[31:0];
						
						end
					
				endcase 

		endcase
		
	// resultado de la alu_6lanes
	assign C = alu_out_temp;
	
	// resultado de la bandera Zero
	assign flagZ = flagZ_aux;
	
endmodule
