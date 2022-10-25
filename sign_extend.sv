module sign_extend(input logic [25:0] num_in,
							input logic imm_src,
							output logic [31:0] num_out);

	always_comb
		case(imm_src)
		
			// 27-bit unsigned immediate
			1'b00: num_out = {{6{num_in[25]}}, num_in[25:0]};
			
			// 17-bit unsigned immediate
			1'b01: num_out = {{14{num_in[17]}}, num_in[17:0]};
			
			default: num_out = 32'bx; // undefined
		endcase
	
endmodule