module mux_4to1 #(parameter S = 32, V=192) 
					(input logic [S-1:0] A, B, C,
					 input logic [V-1:0] D,
					 input logic [1:0] sel,
					 output logic [V-1:0] E);

	always_comb
		case(sel)
		
			// 27-bit unsigned immediate
			2'b00: E = D;
			
			// 01 case:
			2'b01: E = A;
			
			// 01 case:
			2'b10: E = B;
			
			// 11 case:
			2'b11: E = C;
			
			default: E = 192'bx; // undefined
			
		endcase
	
endmodule