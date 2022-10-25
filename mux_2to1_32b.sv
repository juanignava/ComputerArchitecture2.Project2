module mux_2to1_32b #(parameter N=32) (input logic [N-1:0] A, B,
													input logic sel,
													output logic [N-1:0] C);

	always_comb
		case(sel)
		
			1'b0: C = A;		
		
			1'b1: C = B;
			
			default: C = B; // undefined
			
		endcase
	
endmodule