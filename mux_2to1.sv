module mux_2to1 #(parameter V = 192, S = 32) (input logic [S-1:0] A, 
													input logic [V-1:0] B,
													input logic sel,
													output logic [V-1:0] C);

	always_comb
		case(sel)
		
			1'b0: C = A;		
		
			1'b1: C = B;
			
			default: C = B; // undefined
			
		endcase
	
endmodule